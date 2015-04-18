#!/bin/sh

# This script rebuilds dependencies.nix.
# You must run manifest.sh first to download the packages.

# Without arguments, this will use the version of autonix-deps-kf5 in nixpkgs.
# If you are working on the packages, this is probably what you want.

# You can also pass the path to a source tree where you have built
# autonix-deps-kf5 yourself. If you are working on autonix-deps-kf5, this is
# probably what you want.

manifestXML=$(nix-build -E 'with (import ../../../.. {}); autonix.writeManifestXML ./manifest.nix')

autonixDepsKf5=""
if [[ -z $1 ]]; then
    autonixDepsKF5=$(nix-build ../../../.. -A haskellngPackages.autonix-deps-kf5)/bin
else
    autonixDepsKF5="$1/dist/build/kf5-deps"
fi

exec ${autonixDepsKF5}/kf5-deps "${manifestXML}"
