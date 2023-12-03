#!/usr/bin/env python3
from textwrap import dedent
import os.path
import shutil
import stat
import os
import sys


src = sys.argv[1]
dst = sys.argv[2]


def write_bin_wrapper(bin_name):
    """Write a bin wrapper with NIX_PYTHONPATH set"""
    src_bin = os.path.join(src, "bin", bin_name)
    dst_bin = os.path.join(dst, "bin", bin_name)

    script = "#!/usr/bin/env bash" + dedent("""
    export NIX_PYTHONPATH="%s"
    exec %s "$@"
    """ % (os.environ["PYTHONPATH"], src_bin))

    with open(dst_bin, "w") as fd:
        fd.write(script)

        mode = os.fstat(fd.fileno()).st_mode
        mode |= stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH
        os.fchmod(fd.fileno(), stat.S_IMODE(mode))


# If the store path is a simple file no special handling can be done.
st = os.lstat(src)
if not stat.S_ISDIR(st.st_mode):
    os.symlink(src, dst)
    exit(0)

os.mkdir(dst)

for filename in os.listdir(src):
    src_file = os.path.join(src, filename)
    dst_file = os.path.join(dst, filename)

    # Copy nix-support so our builder can add on propagated inputs.
    if filename == "nix-support":
        shutil.copytree(src_file, dst_file)
        continue

    # Wrap bin's in a wrapper that sets NIX_PYTHONPATH.
    if filename == "bin":
        os.mkdir(dst_file)
        for bin_name in os.listdir(src_file):
            write_bin_wrapper(bin_name)
        continue

    # For all other files we place a symlink to the original Python derivation.
    os.symlink(src_file, dst_file)
