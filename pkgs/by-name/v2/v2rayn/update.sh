#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix nix-update

set -eou pipefail

nix-update v2rayn

$(nix-build -A v2rayn.fetch-deps)
