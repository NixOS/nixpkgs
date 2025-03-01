

catch_conflicts.py
==================

The file catch_conflicts.py is in a subdirectory because, if it isn't, the
/nix/store/ directory is added to sys.path causing a delay when building.

Pointers:

- https://docs.python.org/3/library/sys.html#sys.path

- https://github.com/NixOS/nixpkgs/pull/23600
