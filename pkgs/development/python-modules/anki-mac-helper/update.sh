#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p nix nix-update yq-go
set -euo pipefail

nix() { command nix --extra-experimental-features nix-command "$@"; }

# The helper is built from Anki's source, but is versioned separately
src="$(nix-build --no-out-link -A anki.src)"
new_version="$(yq -p toml -o yaml '.project.version' "$src/qt/mac/pyproject.toml")"
old_version="$(nix eval --raw -f . python3Packages.anki-mac-helper.version)"

if [[ "$new_version" == "$old_version" ]]; then
    echo "Already up to date."
    exit 0
fi

echo "Updating anki-mac-helper from $old_version to $new_version..."
nix-update python3Packages.anki-mac-helper --version "$new_version"
