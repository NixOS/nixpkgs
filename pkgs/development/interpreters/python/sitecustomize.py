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

executable = os.environ.pop('NIX_PYTHONEXECUTABLE', None)
if 'PYTHONEXECUTABLE' not in os.environ and executable:
    sys.executable = executable
