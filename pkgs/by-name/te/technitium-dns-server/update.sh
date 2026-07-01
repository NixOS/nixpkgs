#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq common-updater-scripts gnused nix coreutils

set -euo pipefail

latestVersion="$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/TechnitiumSoftware/DnsServer/releases?per_page=1" | jq -r ".[0].tag_name" | sed 's/^v//')"
currentVersion="${UPDATE_NIX_OLD_VERSION:-$(nix-instantiate --eval -E 'with import ./. {}; technitium-dns-server.version or (lib.getVersion technitium-dns-server)' | tr -d '"')}"

if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "technitium-dns-server is up-to-date: $currentVersion"
  exit 0
fi

# Update library (TechnitiumLibrary repo, tag: dns-server-v${version})
update-source-version technitium-dns-server-library "$latestVersion"

# Update main package (DnsServer repo, tag: v${version})
update-source-version technitium-dns-server "$latestVersion"

# Regenerate nuget dependencies for both packages
$(nix-build . -A technitium-dns-server-library.fetch-deps --no-out-link)
$(nix-build . -A technitium-dns-server.fetch-deps --no-out-link)
