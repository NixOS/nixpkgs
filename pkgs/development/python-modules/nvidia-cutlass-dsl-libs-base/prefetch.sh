#! /usr/bin/env nix-shell
#! nix-shell -i sh -p jq

pname="nvidia-cutlass-dsl-libs-base"
outfile="${pname}-hashes.nix"
# Clear file
rm -f $outfile

# The `base` wheel is the one fetched by the derivation itself, the `cu*` ones are fetched by
# `fetchLibsWheel` and merged in `postInstall`.
prefetch() {
  package_attr="python${1}Packages.${pname}"
  echo "Fetching $3 hash for $package_attr on $2"

  expr="(import <nixpkgs> { system = \"$2\"; }).$package_attr.src.url"
  url=$(NIX_PATH=.. nix-instantiate --eval -E "$expr" | jq -r)
  url=$(echo "$url" | sed "s/nvidia_cutlass_dsl_libs_base/nvidia_cutlass_dsl_libs_$3/")

  sha256=$(nix-prefetch-url "$url")
  hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 "$sha256")

  echo -e "  cp${1} = \"${hash}\";" >>$outfile
  echo
}

for flavor in "base" "cu12" "cu13"; do
  echo "${flavor} = {" >>$outfile
  for system in "x86_64-linux" "aarch64-linux"; do
    echo "${system} = {" >>$outfile
    for python_version in "311" "312" "313" "314"; do
      prefetch "$python_version" "$system" "$flavor"
    done
    echo "};" >>$outfile
  done
  echo "};" >>$outfile
done
