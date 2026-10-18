import json
import os
import socket
import subprocess
import sys
import time
import urllib.error
import urllib.request

with socket.socket() as listener:
    listener.bind(("127.0.0.1", 0))
    port = listener.getsockname()[1]

base_url = f"http://127.0.0.1:{port}"
server = subprocess.Popen(
    [
        sys.argv[1],
        "serve",
        "--mode",
        "web",
        "--no-browser",
        "--host",
        "127.0.0.1",
        "--port",
        str(port),
        "--base-dir",
        os.environ["T3CODE_HOME"],
    ],
    stdin=subprocess.DEVNULL,
)

try:
    deadline = time.monotonic() + 60
    while True:
        assert server.poll() is None, f"Server exited with code {server.returncode}"
        try:
            with urllib.request.urlopen(
                f"{base_url}/.well-known/t3/environment", timeout=1
            ) as response:
                assert response.status == 200
                descriptor = json.load(response)
            break
        except urllib.error.HTTPError:
            raise
        except (urllib.error.URLError, TimeoutError):
            if time.monotonic() >= deadline:
                raise TimeoutError("Server did not become ready within 60 seconds")
            time.sleep(0.1)

    assert descriptor["environmentId"], descriptor
    with urllib.request.urlopen(base_url, timeout=5) as response:
        assert response.status == 200
        assert response.headers.get_content_type() == "text/html"
        assert response.read().strip(), "Web entry point is empty"
finally:
    server.terminate()
    try:
        server.wait(timeout=5)
    except subprocess.TimeoutExpired:
        server.kill()
        server.wait()
