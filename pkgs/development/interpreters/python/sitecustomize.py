"""
This is a Nix-specific module for discovering modules built with Nix.

The module recursively adds paths that are on `NIX_PYTHONPATH` to `sys.path`. In
order to process possible `.pth` files `site.addsitedir` is used.

The paths listed in `PYTHONPATH` are added to `sys.path` afterwards, but they
will be added before the entries we add here and thus take precedence.

Note the `NIX_PYTHONPATH` environment variable is unset in order to prevent leakage.
"""
import site
import os
import functools

paths = os.environ.pop('NIX_PYTHONPATH', None)
if paths:
    functools.reduce(lambda k, p: site.addsitedir(p, k), paths.split(':'), site._init_pathinfo())
