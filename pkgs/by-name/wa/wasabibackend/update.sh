#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash -p bash nix nix-update git cacert
set -eo pipefail

prev_version=$(nix eval --raw -f. wasabibackend.version)
nix-update wasabibackend
[[ $(nix eval --raw -f. wasabibackend.version) == "$prev_version" ]] ||
  "$(nix-build . -A wasabibackend.fetch-deps --no-out-link)"
