"""Runs a command, sends it a signal once <ready> exists, and prints how it exited: its exit status, or minus the signal
which killed it.

Usage: signal.py <signal> <ready> <command>...

<signal> is a name (e.g. TERM); ctrl-c, to run the command in a pseudoterminal and type Ctrl-C, which sends SIGINT to
its foreground process group; or none, to send nothing (<ready> is then ignored).
"""

import os
import pty
import signal
import subprocess
import sys
import time


def main() -> None:
    sig, ready, command = sys.argv[1], sys.argv[2], sys.argv[3:]
    if sig == "ctrl-c":
        pid, fd = pty.fork()
        if pid == 0:
            os.execvp(command[0], command)
    else:
        pid = subprocess.Popen(command).pid
    if sig != "none":
        deadline = time.monotonic() + 60
        while not os.path.exists(ready):
            if time.monotonic() > deadline or os.waitpid(pid, os.WNOHANG)[0] != 0:
                sys.exit(f"{command[0]} didn't create {ready}")
            time.sleep(0.05)
        if sig == "ctrl-c":
            os.write(fd, b"\x03")
        else:
            os.kill(pid, signal.Signals[f"SIG{sig}"])
    _, status = os.waitpid(pid, 0)
    print(os.waitstatus_to_exitcode(status))


if __name__ == "__main__":
    main()
