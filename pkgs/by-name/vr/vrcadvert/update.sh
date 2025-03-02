#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash -p bash nix nix-update git cacert
set -eo pipefail

prev_version=$(nix eval --raw -f. vrcadvert.version)
nix-update vrcadvert
[[ $(nix eval --raw -f. vrcadvert.version) == "$prev_version" ]] ||
  $(nix-build . -A vrcadvert.fetch-deps --no-out-link)
