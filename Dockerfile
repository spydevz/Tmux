Dockerfile

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install tmate, tmux, Python for HTTP server, etc.
RUN apt-get update && \
    apt-get install -y tmate tmux curl openssh-client python3 tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Kathmandu /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# Copy the startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8080

CMD ["/start.sh"]


start.sh

#!/bin/bash

# Start dummy HTTP server to keep Render Web Service alive
python3 -m http.server 8080 &

# Start tmate in background
tmate -S /tmp/tmate.sock new-session -d

# Wait for tmate to be ready
tmate -S /tmp/tmate.sock wait tmate-ready

# Print SSH and web access link
echo "=============================="
echo "âœ… Tmate SSH session ready:"
tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}'
echo "ðŸŒ Web URL:"
tmate -S /tmp/tmate.sock display -p '#{tmate_web}'
echo "=============================="

# Keep service running forever
while true; do
    echo "ðŸ’¤ Still alive: $(date)"
    sleep 300
done
