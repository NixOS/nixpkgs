#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq git gnused gnugrep nix libplist undmg
set -euo pipefail

# executing this script without arguments will
# - find the newest stable spotify version avaiable on snapcraft (https://snapcraft.io/spotify)
# - read the current spotify version from the current nix expression
# - update the nix expression if the versions differ
# - try to build the updated version, exit if that fails
# - give instructions for upstreaming

# Please test the update manually before pushing. There have been errors before
# and because the service is proprietary and a paid account is necessary to do
# anything with spotify automatic testing is not possible.

# As an optional argument you can specify the snapcraft channel to update to.
# Default is `stable` and only stable updates should be pushed to nixpkgs. For
# testing you may specify `candidate` or `edge`.

nixpkgs="$(git rev-parse --show-toplevel)"

update_macos() {
  nix_file="$nixpkgs/pkgs/by-name/ti/tidal/package.nix"

  tmp_dir=$(mktemp -d)
  trap 'rm -rf "$tmp_dir"' EXIT

  pushd $tmp_dir

  x86_64_url="https://download.tidal.com/desktop/TIDAL.x64.dmg"
  aarch64_url="https://download.tidal.com/desktop/TIDAL.arm64.dmg"

  curl -OL "$aarch64_url"
  undmg TIDAL.arm64.dmg
  upstream_version=$(plistutil -i TIDAL.app/Contents/Info.plist -f json -o - | jq -r '.CFBundleShortVersionString')

  popd

  current_nix_version=$(
    grep 'version\s*=' "$nix_file" |
      sed -Ene 's/.*"(.*)".*/\1/p'
  )

  if [[ "$current_nix_version" != "$upstream_version" ]]; then
    archive_url="https://web.archive.org/save"
    archived_x86_64_url=$(curl -s -I -L -o /dev/null "$archive_url/$x86_64_url" -w '%{url_effective}')
    archived_aarch64_url=$(curl -s -I -L -o /dev/null "$archive_url/$aarch64_url" -w '%{url_effective}')

    aarch64_hash=$(nix-prefetch-url "$archived_aarch64_url" --type sha256 | xargs nix hash convert --hash-algo sha256 --to sri)
    x86_64_hash=$(nix-prefetch-url "$archived_x86_64_url" --type sha256 | xargs nix hash convert --hash-algo sha256 --to sri)

    sed --regexp-extended \
      -e 's/version\s*=\s*".*"\s*;/version = "'"${upstream_version}"'";/' \
      -i "$nix_file"

    # Update aarch64 (first fetchurl block) url and hash
    sed -e '/isAarch64/,/})/{
      s|url = ".*"|url = "'"${archived_aarch64_url}"'"|
      s|hash = ".*"|hash = "'"${aarch64_hash}"'"|
    }' -i "$nix_file"

    # Update x86_64 (second fetchurl block) url and hash
    sed -e '/else/,/})/{
      s|url = ".*"|url = "'"${archived_x86_64_url}"'"|
      s|hash = ".*"|hash = "'"${x86_64_hash}"'"|
    }' -i "$nix_file"
  fi
}

update_macos
