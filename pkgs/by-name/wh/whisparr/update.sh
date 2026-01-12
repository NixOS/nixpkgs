#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused jq nix-prefetch
#shellcheck shell=bash

set -e

dirname="$(dirname "$0")"

updateVersion() {
  version=$1
  echo "Updating the version..."
  sed -i "s#version = \"[0-9.]*\"#version = \"$version\"#" "$dirname/package.nix"
}

updateHash()
{
  version=$1
  arch=$2
  os=$3

  system="${arch}-${os}"
  hashKey="${system}-hash"

  echo "Updating the hash for the \`${system}\` system..."
  url="https://whisparr.servarr.com/v1/update/nightly/updatefile?runtime=netcore&version=${version}&arch=${arch}&os=${os}"
  hash=$(nix-prefetch-url --type sha256 --name "whisparr-$system-$version.tar.gz" "$url")
  sriHash="$(nix --extra-experimental-features nix-command hash to-sri --type sha256 "$hash")"

  sed -i "s#$hashKey = \"[a-zA-Z0-9\/+-=]*\"#$hashKey = \"$sriHash\"#" "$dirname/package.nix"
}

echo "Checking for updates of Whisparr..."

currentVersion=$(nix eval --raw -f "$dirname"/../../../.. whisparr.version)
echo "Current version: \`$currentVersion\`."

echo "Fetching the latest version..."
latestVersion=$(
  curl -s "https://whisparr.servarr.com/v1/update/nightly/changes?runtime=netcore&os=linux" |
  jq -r .[0].version
)

if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "Whisparr is up-to-date."
  exit 0
else
  echo "New version is available: \`$latestVersion\`."
fi

updateHash "$latestVersion" arm64 linux
updateHash "$latestVersion" arm64 osx
updateHash "$latestVersion" x64 linux
updateHash "$latestVersion" x64 osx

updateVersion "$latestVersion"
