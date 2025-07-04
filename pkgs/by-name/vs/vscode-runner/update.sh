#!/usr/bin/env nix-shell
#!nix-shell -i bash -p yq jq common-updater-scripts dart

set -xeu -o pipefail

PACKAGE_DIR="$(realpath "$(dirname "$0")")"
cd "$PACKAGE_DIR/.."
while ! test -f flake.nix; do cd ..; done
NIXPKGS_DIR="$PWD"

# Get latest version number from GitHub
version="$(
  curl --silent https://api.github.com/repos/Merrit/vscode-runner/releases/latest |
    jq '.tag_name | ltrimstr("v")' --raw-output
)"

# Update to latest version
cd "$NIXPKGS_DIR"
update-source-version vscode-runner "$version"

# Create new pubspec.lock.json
TMPDIR="$(mktemp -d)"
cd "$TMPDIR"

src=$(nix-build --no-link "$NIXPKGS_DIR" -A vscode-runner.src)
cp $src/pubspec.* .

if ! test -f pubspec.lock; then
  dart pub update
fi

yq . pubspec.lock > "$PACKAGE_DIR/pubspec.lock.json"

rm -rf "$TMPDIR"
