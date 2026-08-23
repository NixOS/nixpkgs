#!/usr/bin/env python3
"""Minimal LSP smoke test for elm-language-server."""
import json
import subprocess
import sys
import threading

def make_message(payload: dict) -> bytes:
    body = json.dumps(payload).encode("utf-8")
    header = f"Content-Length: {len(body)}\r\n\r\n".encode("utf-8")
    return header + body

def read_message(stream) -> dict:
    # Read headers
    headers = {}
    while True:
        line = stream.readline()
        if line in (b"\r\n", b"\n", b""):
            break
        if b":" in line:
            key, _, value = line.partition(b":")
            headers[key.strip().lower()] = value.strip()
    length = int(headers.get(b"content-length", b"0"))
    body = stream.read(length)
    return json.loads(body)

def read_messages(n, label, stream) -> ():
    if n == 0:
        return ()
    resp = read_message(stream)
    print(label, n, json.dumps(resp, indent=2))
    return read_messages(n-1, label, stream)

def main():
    elmLsp = sys.argv[1]
    projDir = sys.argv[2]

    proc = subprocess.Popen(
        [elmLsp, "--stdio"],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )

    # Print stderr in background so you can see server logs / crashes
    def pump_stderr():
        for line in proc.stderr:
            sys.stderr.buffer.write(b"[stderr] " + line)
            sys.stderr.flush()
    threading.Thread(target=pump_stderr, daemon=True).start()

    def send(payload):
        msg = make_message(payload)
        print("sending:")
        print(msg)
        proc.stdin.write(msg)
        proc.stdin.flush()

    # 1. initialize
    send({
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
            "processId": None,
            "rootUri": f'file://{projDir}',
            "capabilities": {},
        },
    })
    read_messages(5, "initialize response", proc.stdout)

    # 2. initialized notification
    send({"jsonrpc": "2.0", "method": "initialized", "params": {}})
    read_messages(129, "initialized response", proc.stdout)

    # 3. open a fake document (definition/hover usually require an open doc)
    uri = f'file://{projDir}/src/Main.elm'
    # text = "module Main exposing (main)\n\nmain =\n    1\n"
    send({
        "jsonrpc": "2.0",
        "method": "textDocument/didOpen",
        "params": {
            "textDocument": {
                "uri": uri,
                "languageId": "elm",
                "version": 1 #,
                # "text": text,
            }
        },
    })
    read_messages(1, "didOpen response", proc.stdout)

    # 4. request definition at some position
    send({
        "jsonrpc": "2.0",
        "id": 2,
        "method": "textDocument/definition",
        "params": {
            "textDocument": {"uri": uri},
            # the 'text' in the 'Html' import line
            "position": {"line": 2, "character": 29},
        },
    })
    read_messages(2, "definition response", proc.stdout)

    # 5. shutdown cleanly
    send({"jsonrpc": "2.0", "id": 3, "method": "shutdown", "params": None})
    read_messages(1, "shutdown response", proc.stdout)

    send({"jsonrpc": "2.0", "method": "exit"})

    proc.wait(timeout=5)

if __name__ == "__main__":
    main()
