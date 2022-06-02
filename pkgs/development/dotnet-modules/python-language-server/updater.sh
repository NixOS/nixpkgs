#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gnused jq common-updater-scripts nuget-to-nix dotnet-sdk_3 nix-prefetch-git
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
store_src="$(nix-build -A python-language-server.src --no-out-link)"
src="$(mktemp -d /tmp/pylang-server-src.XXX)"
cp -rT "$store_src" "$src"
chmod -R +w "$src"

pushd "$src"

export DOTNET_NOLOGO=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1

mkdir ./nuget_pkgs
dotnet restore src/LanguageServer/Impl/Microsoft.Python.LanguageServer.csproj --packages ./nuget_pkgs

nuget-to-nix ./nuget_pkgs > "$deps_file"

trap ''
  rm -r "$src"
'' EXIT
