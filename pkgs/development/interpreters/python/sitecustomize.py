"""
This is a Nix-specific module for discovering modules built with Nix.

The module recursively adds paths that are on `NIX_PYTHONPATH` to `sys.path`. In
order to process possible `.pth` files `site.addsitedir` is used.

The paths listed in `PYTHONPATH` are added to `sys.path` afterwards, but they
will be added before the entries we add here and thus take precedence.

Note the `NIX_PYTHONPATH` environment variable is unset in order to prevent leakage.

Similarly, this module listens to the environment variable `NIX_PYTHONEXECUTABLE`
and sets `sys.executable` to its value.
"""
import site
import sys
import os
import functools

paths = os.environ.pop('NIX_PYTHONPATH', None)
if paths:
    functools.reduce(lambda k, p: site.addsitedir(p, k), paths.split(':'), site._init_pathinfo())

# Check whether we are in a venv. 
# Note Python 2 does not support base_prefix so we assume we are not in a venv.
in_venv = sys.version_info.major == 3 and sys.prefix != sys.base_prefix

if not in_venv:
    executable = os.environ.pop('NIX_PYTHONEXECUTABLE', None)
    prefix = os.environ.pop('NIX_PYTHONPREFIX', None)

    if 'PYTHONEXECUTABLE' not in os.environ and executable is not None:
        sys.executable = executable
    if prefix is not None:
        # Because we cannot check with Python 2 whether we are in a venv, 
        # creating a venv from a Nix env won't work as well with Python 2.
        # Also, note that sysconfig does not like it when sys.prefix is set to None
        sys.prefix = sys.exec_prefix = prefix
        site.PREFIXES.insert(0, prefix)
