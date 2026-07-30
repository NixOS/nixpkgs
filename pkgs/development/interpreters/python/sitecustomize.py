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

# Check whether we are in a venv or virtualenv.
# For Python 3 we check whether our `base_prefix` is different from our current `prefix`.
# For Python 2 we check whether the non-standard `real_prefix` is set.
# https://stackoverflow.com/questions/1871549/determine-if-python-is-running-inside-virtualenv
in_venv = (sys.version_info.major == 3 and sys.prefix != sys.base_prefix) or (sys.version_info.major == 2 and hasattr(sys, "real_prefix"))

if not in_venv:
    executable = os.environ.pop('NIX_PYTHONEXECUTABLE', None)
    prefix = os.environ.pop('NIX_PYTHONPREFIX', None)

    if 'PYTHONEXECUTABLE' not in os.environ and executable is not None:
        sys.executable = executable
    if prefix is not None:
        # Sysconfig does not like it when sys.prefix is set to None
        sys.prefix = sys.exec_prefix = prefix
        site.PREFIXES.insert(0, prefix)
