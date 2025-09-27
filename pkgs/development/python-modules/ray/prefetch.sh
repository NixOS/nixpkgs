#! /usr/bin/env nix-shell
#! nix-shell -i sh -p jq

outfile="ray-hashes.nix"
# Clear file
rm -f $outfile

prefetch() {
  package_attr="python${1}Packages.ray"
  echo "Fetching hash for $package_attr on $2"

  expr="(import <nixpkgs> { system = \"$2\"; }).$package_attr.src.url"
  url=$(NIX_PATH=.. nix-instantiate --eval -E "$expr" | jq -r)

  sha256=$(nix-prefetch-url "$url")
  hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 "$sha256")

  echo -e "  cp${1} = \"${hash}\";" >>$outfile
  echo
}

for system in "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"; do
  echo "${system} = {" >>$outfile
  for python_version in "310" "311" "312" "313"; do
    prefetch "$python_version" "$system"
  done
  echo "};" >>$outfile
done
