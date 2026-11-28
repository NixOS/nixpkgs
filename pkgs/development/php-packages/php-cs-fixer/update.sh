#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq php.packages.composer nix-update coreutils

set -eou pipefail

PACKAGE_NAME="phpPackages.php-cs-fixer"
PACKAGE_VERSION=$(nix eval --raw -f. $PACKAGE_NAME.version)
PACKAGE_DIR="$(dirname "${BASH_SOURCE[0]}")"

# Get latest version from git
GIT_VERSION="$(curl --silent ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/PHP-CS-Fixer/PHP-CS-Fixer/releases/latest" | jq '.tag_name' --raw-output)"
NEW_VERSION="${GIT_VERSION#v}"

# Fail if package and git version are the same
if [[ "$PACKAGE_VERSION" == "$NEW_VERSION" ]]; then
    echo "${PACKAGE_NAME} is up-to-date: ${PACKAGE_VERSION}"
    exit 0
fi

# Generate composer.lock file
TMPDIR=$(mktemp -d)
trap 'rm -rf -- "${TMPDIR}"' EXIT

git clone --depth 1 --branch "${GIT_VERSION}" https://github.com/PHP-CS-Fixer/PHP-CS-Fixer.git "${TMPDIR}/php-cs-fixer"
rm -f "${TMPDIR}/php-cs-fixer/composer.lock"
# Resolve for the oldest PHP in nixpkgs
OLDEST_PHP=$(nix eval --raw --impure --expr '
  let
    pkgs = import ./. { };
    inherit (pkgs) lib;
    interpreters = pkgs.callPackage ./pkgs/development/interpreters/php { };
    versions = lib.mapAttrsToList (_: php: php.version) (
      lib.filterAttrs (name: _: builtins.match "php[0-9]+" name != null) interpreters
    );
  in
  lib.head (lib.sort lib.versionOlder versions)
')
cp "${TMPDIR}/php-cs-fixer/composer.json" "${TMPDIR}/composer.json.orig"
composer -d "${TMPDIR}/php-cs-fixer" config platform.php "${OLDEST_PHP}"
composer -d "${TMPDIR}/php-cs-fixer" update --no-scripts
# Drop the override again and refresh only the content-hash, so the lock matches upstream composer.json
cp "${TMPDIR}/composer.json.orig" "${TMPDIR}/php-cs-fixer/composer.json"
composer -d "${TMPDIR}/php-cs-fixer" update --lock --no-install --no-scripts
cp "${TMPDIR}/php-cs-fixer/composer.lock" "${PACKAGE_DIR}/composer.lock"

# update package.nix version, hash and vendorHash
nix-update $PACKAGE_NAME --version="${NEW_VERSION}"
