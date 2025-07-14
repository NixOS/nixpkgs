cd "$PKG_DIR"

# Update lockfile
version="$(npm view typescript version)"
npm pack typescript
tar xvf "typescript-${version}.tgz"
mv package/package.json ./
npm install --package-lock-only
npmDepsHash=$(prefetch-npm-deps ./package-lock.json)
rm -rf ./package ./package.json ./"typescript-${version}.tgz"

cd -

# Update version and hashes
nix-update "$PNAME" --version "$version"
sed -E 's#\bnpmDepsHash = ".*?"#npmDepsHash = "'"$npmDepsHash"'"#' -i "$PKG_DIR/package.nix"
