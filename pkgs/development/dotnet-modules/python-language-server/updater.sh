#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p gnused jq common-updater-scripts nix-prefetch-git
set -eo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

deps_file="$(realpath ./deps.nix)"

nix-prefetch-git https://github.com/microsoft/python-language-server --quiet > repo_info
new_version="$(jq -r ".date" < repo_info | cut -d"T" -f1)"
new_hash="$(jq -r ".sha256" < repo_info)"
new_rev="$(jq -r ".rev" < repo_info)"
rm repo_info

old_rev="$(sed -nE 's/\s*rev = "(.*)".*/\1/p' ./default.nix)"

if [[ $new_rev == $old_rev ]]; then
  echo "Already up to date!"
  exit 0
fi

pushd ../../../..
update-source-version python-language-server "$new_version" "$new_hash" --rev="$new_rev"
$(nix-build -A python-language-server.fetch-deps --no-out-link) "$deps_file"
