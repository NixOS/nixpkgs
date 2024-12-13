#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash -p bash nix nix-update git cacert
set -eo pipefail

prev_version=$(nix eval --raw -f. tone.version)
nix-update tone
[[ $(nix eval --raw -f. tone.version) == "$prev_version" ]] ||
  "$(nix-build . -A tone.fetch-deps --no-out-link)"
