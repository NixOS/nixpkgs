#!/usr/bin/env nix-shell
#!nix-shell -i bash -p yq ripgrep common-updater-scripts nodejs prefetch-npm-deps

set -xeu -o pipefail

PACKAGE_DIR="$(realpath "$(dirname "$0")")"
cd "$PACKAGE_DIR/.."
while ! test -f default.nix; do cd .. ; done
NIXPKGS_DIR="$PWD"

version="$(
  list-git-tags --url=https://github.com/mishoo/UglifyJS \
  | rg '^v([\d.]+)$' -r '$1' \
  | sort --version-sort \
  | tail -n1
)"
update-source-version uglify-js "$version"

TMPDIR="$(mktemp -d)"
trap "rm -rf '$TMPDIR'" EXIT
cd "$TMPDIR"

src="$(nix-build --no-link "$NIXPKGS_DIR" -A uglify-js.src)"
cp $src/package*.json .

# Maybe one day upstream may ship a package-lock.json,
# until then we must generate a fresh one
test -f package-lock.json || npm install
cp -v package-lock.json "$PACKAGE_DIR/package-lock.json"

npmDepsHash=$(prefetch-npm-deps ./package-lock.json)
sed -E "s@npmDepsHash = \".*?\"@npmDepsHash = \"$npmDepsHash\"@" -i "$PACKAGE_DIR/package.nix"
