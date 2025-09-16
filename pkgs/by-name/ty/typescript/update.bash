pkg_file="$PKG_DIR/package.nix"

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
NEW_NPM_DEPS_HASH=$(prefetch-npm-deps ./package-lock.json)
cd -

# Update version and src hash
nix-update "$PNAME" --version "$version"

# Update npmDepsHash
pkg_body="$(<"$pkg_file")"
pkg_body="${pkg_body//"$OLD_NPM_DEPS_HASH"/"$NEW_NPM_DEPS_HASH"}"
echo "$pkg_body" >"$pkg_file"
