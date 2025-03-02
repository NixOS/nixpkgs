#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update subversion

new_version=$(svn ls https://abcl.org/svn/tags | tail -1 | tr -d /)
nix-update abcl --version "$new_version"
