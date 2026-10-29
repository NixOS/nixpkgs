#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep gnused jq

set -euo pipefail

cd $(dirname ${BASH_SOURCE[0]})

# Detect latest tag
latestVersion=$(curl --silent ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
    'https://api.github.com/repos/LPCIC/elpi/releases' | jq -r 'map(.tag_name).[0]' | sed 's/^v//')

# Detect current tag
currentVersion=$(sed -e "/    if lib.versionAtLeast ocaml.version \"4.13\" then/{n;q}" default.nix | tail -n 1 | sed 's/[[:space:]"]//g')

if [ "$latestVersion" == "$currentVersion" ]
then
  echo "Already up to date"
  exit 0
fi

# Get hash for latest tag
versionCommit=$(curl --silent ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
    'https://api.github.com/repos/LPCIC/elpi/tags' | \
    jq -r "map(select(.name == \"v$latestVersion\")) | .[0] | .commit.sha")

ELPI_GIT_PREFETCH=$(nix-prefetch-url --unpack https://github.com/LPCIC/elpi/archive/${versionCommit}.tar.gz)
ELPI_GIT_HASH=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 ${ELPI_GIT_PREFETCH})

# We register the new version
sed "/fetched = coqPackages.metaFetch {/a\\    release.\"$latestVersion\".sha256 = \"$ELPI_GIT_HASH\";" -i default.nix

# We set it as default
sed "/    if lib.versionAtLeast ocaml.version \"4.13\" then/{n;d}" -i default.nix
sed "/    else if lib.versionAtLeast ocaml.version \"4.08\" then/i\\      \"$latestVersion\"" -i default.nix
