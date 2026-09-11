{
  writeShellApplication,
  curl,
  jq,
  common-updater-scripts,
  cargo,
}:

writeShellApplication {
  name = "update-terracotta";
  runtimeInputs = [
    curl
    jq
    common-updater-scripts
    cargo
  ];

  text = ''
    get_latest_release() {
        curl --fail ''${GITHUB_TOKEN:+ -H "Authorization: bearer $GITHUB_TOKEN"} \
             -s "https://api.github.com/repos/burningtnt/Terracotta/releases/latest" | jq -r ".tag_name"
    }

    version=$(get_latest_release)
    version="''${version#v}"

    if [[ "$UPDATE_NIX_OLD_VERSION" == "$version" ]]; then
        echo "Already up to date!"
        exit 0
    fi

    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' EXIT

    update-source-version terracotta "$version"

    cp -r "$(nix-build --no-link -A terracotta.src)" "$tmp/src"
    chmod -R +w "$tmp/src"

    pushd "$tmp/src"
    sed -i '/EasyTier.git/d' Cargo.toml
    cargo generate-lockfile
    popd

    cp "$tmp/src/Cargo.lock" "pkgs/by-name/te/terracotta/Cargo.lock"
  '';
}
