#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=../../../../.. -i ysh -p oils-for-unix chicken nix-prefetch-git jq

# Regenerates the egg set of one CHICKEN release from upstream's list of latest
# egg releases.  The metadata reader is version agnostic, so any csi will do.
#
#   usage: ./update.sh <chicken major version>

if (len(ARGV) !== 1) {
  echo "usage: $0 <chicken major version>" >&2
  exit 2
}

var chicken_major_version = ARGV[0]
var deps = "$_this_dir/../$chicken_major_version/deps.toml"

setglobal ENV.URL_PREFIX="https://code.call-cc.org/egg-tarballs/$chicken_major_version/"
cd $(nix-prefetch-git --deepClone --quiet \
       "https://code.call-cc.org/eggs-$chicken_major_version-latest" | jq --raw-output .path)

echo "# THIS IS A GENERATED FILE.  DO NOT EDIT!" > $deps
for i, item in */*/*.egg {
  setglobal ENV.EGG_NAME=$(dirname $(dirname $item))
  setglobal ENV.EGG_FILE=$(basename $item)
  # Eggs may ship .egg files other than their own, which are not releases of
  # their own and have no tarball to fetch.
  if test $[ENV.EGG_FILE] != "$[ENV.EGG_NAME].egg" { continue }
  setglobal ENV.EGG_VERSION=$(basename $(dirname $item))
  setglobal ENV.EGG_URL="$[ENV.URL_PREFIX]$[ENV.EGG_NAME]/$[ENV.EGG_NAME]-$[ENV.EGG_VERSION].tar.gz"
  setglobal ENV.EGG_SHA256=$(nix-prefetch-url $[ENV.EGG_URL])
  csi -s $_this_dir/read-egg.scm < $item
} >> $deps
