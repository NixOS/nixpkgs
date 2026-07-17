#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update

nix-update --override-filename pkgs/by-name/ui/uiua/unstable.nix --version unstable --version-regex '^(\d*\.\d*\.\d*.*)$' uiua-unstable
