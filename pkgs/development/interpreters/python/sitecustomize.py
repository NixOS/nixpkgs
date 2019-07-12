"""
This is a Nix-specific module for discovering modules built with Nix.

The module recursively adds paths that are on `NIX_PYTHONPATH` to `sys.path`. In
order to process possible `.pth` files `site.addsitedir` is used.

The paths listed in `PYTHONPATH` are added to `sys.path` afterwards, but they
will be added before the entries we add here and thus take precedence.

Note the `NIX_PYTHONPATH` environment variable in unset in order to prevent leakage.
"""
import site
import os
import functools

paths = os.environ.pop('NIX_PYTHONPATH', None)
if paths:
    functools.reduce(lambda k, p: site.addsitedir(p, k), paths.split(':'), site._init_pathinfo())


"""
Set `sys.argv[0] of our script.
"""
import sys

def argv0_setter_hook(path):
    """Hook to set argv0.

    The Python interpreter doesn't listen to `exec -a`. This
    hook will set argv0 to the value of `NIX_PYTHON_SCRIPT_NAME`.
    """
    if hasattr(sys, 'argv'):
        # Remove this hook
        sys.path_hooks.remove(argv0_setter_hook)

        import os
        import functools
        import site

        sys.argv[0] = os.environ.pop('NIX_PYTHON_SCRIPT_NAME', sys.argv[0])

    raise ImportError # Let the real import machinery do its work

sys.path_hooks.append(argv0_setter_hook)