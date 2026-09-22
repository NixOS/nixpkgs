#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update jq gitMinimal

set -euo pipefail

nix-update texlyre

PKG_DIR=$(realpath "$(dirname "$0")")
NIXPKGS_ROOT="$(git rev-parse --show-toplevel)"
SRC_DIR=$(nix-build -E "(import \"$NIXPKGS_ROOT\" {}).texlyre.src" --no-out-link)
ASSETS_SCRIPT="$SRC_DIR/scripts/download-core-assets.cjs"

DRAWIO_VERSION=$(grep -A 2 "name: 'drawio-embed'" "$ASSETS_SCRIPT" | grep "version:" | cut -d "'" -f 2 | sed 's/^v//')
BUSYTEX_VERSION=$(grep -A 2 "name: 'texlyre-busytex'" "$ASSETS_SCRIPT" | grep "version:" | cut -d "'" -f 2 | sed 's/^v//')

echo "Updating: drawio-embed=$DRAWIO_VERSION, busytex=$BUSYTEX_VERSION"

nix-update texlyre.passthru.drawioEmbed --version "$DRAWIO_VERSION"
nix-update texlyre.passthru.busytexAssets --version "$BUSYTEX_VERSION"
