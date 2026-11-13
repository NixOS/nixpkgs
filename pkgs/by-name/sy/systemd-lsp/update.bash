# Update releaseDate
release_date="$(curl --fail --silent 'https://api.github.com/repos/JFryy/systemd-lsp/releases/latest' | yq '.tag_name | sub("^v", "")')"
update-source-version "$UPDATE_NIX_PNAME" "$release_date" --version-key=releaseDate

# Update crateVersion
new_src="$(nix-build --attr "pkgs.$UPDATE_NIX_PNAME.src" --no-out-link)"
new_crate_ver="$(yq '.package.version' "$new_src/Cargo.toml")"
update-source-version "$UPDATE_NIX_PNAME" "$new_crate_ver" --version-key=crateVersion --ignore-same-version --ignore-same-hash

# Update cargoHash
nix-update --version=skip "$UPDATE_NIX_PNAME"
