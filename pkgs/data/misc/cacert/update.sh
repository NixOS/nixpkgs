#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix common-updater-scripts jq

# Build both the cacert package and an overriden version where we use the source attribute of NSS.
# Cacert and NSS are both from the same upstream sources. They are decoupled as
# the cacert output only cares about a few infrequently changing files in the
# sources while the NSS source code changes frequently.
#
# By having cacert on a older source revision that produces the same
# certificate output as a newer version we can avoid large amounts of
# unnecessary rebuilds.
#
# As of this writing there are a few magnitudes more packages depending on
# cacert than on nss.


set -ex

BASEDIR="$(dirname "$0")/../../../.."


CURRENT_PATH=$(nix-build --no-out-link -A cacert.out)
PATCHED_PATH=$(nix-build --no-out-link -E "with import $BASEDIR {}; (cacert.overrideAttrs (_: { inherit (nss) src version; })).out")

# Check the hash of the etc subfolder
# We can't check the entire output as that contains the nix-support folder
# which contains the output path itself.
CURRENT_HASH=$(nix-hash "$CURRENT_PATH/etc")
PATCHED_HASH=$(nix-hash "$PATCHED_PATH/etc")

if [[ "$CURRENT_HASH" !=  "$PATCHED_HASH" ]]; then
    NSS_VERSION=$(nix-instantiate --json --eval -E "with import $BASEDIR {}; nss.version" | jq -r .)
    update-source-version cacert "$NSS_VERSION"
fi
