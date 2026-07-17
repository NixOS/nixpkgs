import os
import subprocess
import sys

__version__ = '@version@'

BIN_DIR = '@BIN_DIR@'

def _program(name, args):
    return subprocess.call([os.path.join(BIN_DIR, name)] + args, close_fds=False)

def ninja():
    raise SystemExit(_program('ninja', sys.argv[1:]))
