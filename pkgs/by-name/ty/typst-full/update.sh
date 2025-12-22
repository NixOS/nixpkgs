#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix

set -euxo pipefail

maintainers/scripts/update-typst-packages.py --output "pkgs/by-name/ty/typst/typst-packages-from-universe.toml" > /dev/null

sed -i -E "s|(version = \")[^\"]*(\";)|\10-unstable-$(date -u +%F)\2|" pkgs/by-name/ty/typst-full/package.nix
