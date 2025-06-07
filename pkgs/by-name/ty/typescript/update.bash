cd "$PKG_DIR"

# Update lockfile
rm ./package-lock.json
version="$(npm view typescript version)"
npm pack typescript
tar xvf "typescript-${version}.tgz"
# Minimize size of package-lock.json
jq 'del(.devDependencies)' package/package.json > package.json
npm install --package-lock-only
rm -rf ./package ./package.json ./"typescript-${version}.tgz"
# npmDepsHash=$(prefetch-npm-deps ./package-lock.json) # Cannot use this way, How to specify forceEmptyCache here?
cd -

# Update version and hashes
nix-update "$PNAME" --version "$version"
# sed -E 's#\bnpmDepsHash = ".*?"#npmDepsHash = "'"$npmDepsHash"'"#' -i "$PKG_DIR/package.nix" # Comment-out if prefetch-npm-deps useable
echo "You should manually update npmDepsHash"
