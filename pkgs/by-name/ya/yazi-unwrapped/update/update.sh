#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-update curl coreutils jq common-updater-scripts yq-go trurl nix-prefetch ast-grep git

set -euxo pipefail

NIXPKGS_DIR="$PWD"
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

# Get latest release
YAZI_RELEASE=$(
    curl --silent ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
        https://api.github.com/repos/sxyazi/yazi/releases/latest
)

# Get release information
latestBuildDate=$(echo "$YAZI_RELEASE" | jq -r ".published_at")
tagName=$(echo "$YAZI_RELEASE" | jq -r ".tag_name")

latestBuildDate="${latestBuildDate%T*}" # remove the timestamp and get the date
latestVersion="${tagName:1}"            # remove first char 'v'

oldVersion=$(nix eval --raw -f "$NIXPKGS_DIR" yazi-unwrapped.version)

if [[ "$oldVersion" == "$latestVersion" ]]; then
    echo "Yazi is up-to-date: ${oldVersion}"
    exit 0
fi

echo "Updating Yazi"

# Version
update-source-version yazi-unwrapped "${latestVersion}"

pushd "$SCRIPT_DIR/.."
# Build date
sed -i 's#env.VERGEN_BUILD_DATE = "[^"]*"#env.VERGEN_BUILD_DATE = "'"${latestBuildDate}"'"#' package.nix

# Cargo.lock
curl -L -o 'Cargo.lock' "https://raw.githubusercontent.com/sxyazi/yazi/$tagName/Cargo.lock"
gitPackages=$(yq eval '[.package[] | select(.source == "git+*") | pick(["name", "version", "source"])]' Cargo.lock --input-format toml --output-format json | jq -c '.[]')

if [[ -n "$gitPackages" ]]; then
    # Has git packages, use cargoLock
    # Fetch git packages hashes
    declare -A packageHashs
    for gitPackage in $gitPackages; do
        packageKey=$(echo "$gitPackage" | jq -r '.name + "-" + .version')

        # https://github.com/NixOS/nixpkgs/blob/8fea621314ee47610b2e451b28569351021907cf/pkgs/build-support/rust/import-cargo-lock.nix#L32
        gitSource=$(echo "$gitPackage" | jq -r '.source')
        gitSourceUrl=$(trurl --url "${gitSource#git+}" --get '{scheme}://{host}{path}')
        gitSourceFragment=$(trurl --url "${gitSource#git+}" --get '{fragment}')
        packageHash=$(nix-prefetch fetchgit --url "$gitSourceUrl" --rev "$gitSourceFragment")

        packageHashs["$packageKey"]="$packageHash"
    done

    # Generate cargoLock parameters
    cargoLockLines=$(
        cat <<END
cargoLock = {
  lockFile = ./Cargo.lock;
  outputHashes = {
END
    )
    for packageName in "${!packageHashs[@]}"; do
        cargoLockLines=$(
            cat <<END
$cargoLockLines
    "$packageName" = "${packageHashs[$packageName]}";
END
        )
    done
    cargoLockLines=$(
        cat <<END
$cargoLockLines
  };
};
END
    )

    # Update package.nix
    sgconfigDir=$(nix-build ./update/sgconfig.nix --arg pkgs "(import $NIXPKGS_DIR {})" --argstr cargoHashOrLock "$cargoLockLines" --no-out-link)
    sg scan --config "$sgconfigDir/sgconfig.yml" --update-all
    git add 'Cargo.lock'
else
    # No git packages, use cargoHash
    # Remove existed cargoLock parameters to avoid the error of https://github.com/NixOS/nixpkgs/blob/8fea621314ee47610b2e451b28569351021907cf/pkgs/build-support/rust/import-cargo-lock.nix#L86
    sgconfigDir=$(nix-build ./update/sgconfig.nix --arg pkgs "(import $NIXPKGS_DIR {})" --argstr cargoHashOrLock "cargoHash = \"\";" --no-out-link)
    sg scan --config "$sgconfigDir/sgconfig.yml" --update-all

    # Fetch cargoHash
    cargoHash=$(nix-prefetch "{ sha256 }: (import $NIXPKGS_DIR {}).yazi-unwrapped.cargoDeps.overrideAttrs (_: { outputHash = sha256; })")
    # Update package.nix
    sgconfigDir=$(nix-build ./update/sgconfig.nix --arg pkgs "(import $NIXPKGS_DIR {})" --argstr cargoHashOrLock "cargoHash = \"$cargoHash\";" --no-out-link)
    sg scan --config "$sgconfigDir/sgconfig.yml" --update-all
    rm 'Cargo.lock'
fi

popd
