#!/usr/bin/env python3
from functools import wraps
from textwrap import dedent
import os.path
import stat
import os
import sys


src = sys.argv[1]
dst = sys.argv[2]


def write_bin_wrapper(bin_name):
    """Write a bin wrapper with NIX_PYTHONPATH set"""
    src_bin = os.path.join(src, "bin", bin_name)
    dst_bin = os.path.join(dst, "bin", bin_name)

    # TODO: Non-executable files

    script = "#!/usr/bin/env bash" + dedent("""
    export NIX_PYTHONPATH="%s"
    exec %s "$@"
    """ % (os.environ["PYTHONPATH"], src_bin))

    with open(dst_bin, "w") as fd:
        fd.write(script)

        mode = os.fstat(fd.fileno()).st_mode
        mode |= stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH
        os.fchmod(fd.fileno(), stat.S_IMODE(mode))


@wraps(os.mkdir)
def mkdir(*args, **kwargs):
    """Wraps os.mkdir but doesn't fail on existing file"""
    try:
        os.mkdir(*args, **kwargs)
    except FileExistsError:
        pass


def symlink_tree(src: str, dst: str):
    mkdir(dst)

    for root, dirs, files in os.walk(src):
        dst_dir = os.path.join(dst, root.removeprefix(src).removeprefix(os.path.sep))
        mkdir(dst_dir)

        for dir in dirs:
            mkdir(os.path.join(dst_dir, dir))
        for filename in files:
            os.symlink(os.path.join(root, filename), os.path.join(dst_dir, filename))


if __name__ == "__main__":
    # If the store path is a simple file no special handling can be done.
    st = os.lstat(src)
    if not stat.S_ISDIR(st.st_mode):
        os.symlink(src, dst)
        exit(0)

    os.mkdir(dst)

    for filename in os.listdir(src):
        src_file = os.path.join(src, filename)
        dst_file = os.path.join(dst, filename)

        # Wrap bin's in a wrapper that sets NIX_PYTHONPATH.
        if filename == "bin":
            os.mkdir(dst_file)
            for bin_name in os.listdir(src_file):
                write_bin_wrapper(bin_name)
            continue

        st = os.lstat(src_file)
        if stat.S_ISDIR(st.st_mode):
            symlink_tree(src_file, dst_file)
            continue

        # For all other files we place a symlink to the original Python derivation.
        os.symlink(src_file, dst_file)
