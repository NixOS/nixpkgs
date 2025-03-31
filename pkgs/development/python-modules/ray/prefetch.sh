#! /usr/bin/env nix-shell
#! nix-shell -i sh -p jq

outfile="ray-hashes.nix"
# Clear file
echo "" >$outfile

prefetch() {
    package_attr="python${2}Packages.${1}"
    echo "Fetching hash for $package_attr on $3"

    expr="(import <nixpkgs> { system = \"$3\"; }).$package_attr.src.url"
    url=$(NIX_PATH=.. nix-instantiate --eval -E "$expr" | jq -r)

    sha256=$(nix-prefetch-url "$url")
    hash=$(nix hash convert --to sri --hash-algo sha256 "$sha256")

    echo -e "    cp${2} = \"${hash}\";" >>$outfile
    echo
}

for package_name in "ray" "ray-cpp"; do
    echo "${package_name} = {" >>$outfile
    for system in "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"; do
        echo "  ${system} = {" >>$outfile
        for python_version in "39" "310" "311" "312"; do
            prefetch "$package_name" "$python_version" "$system"
        done
        echo "  };" >>$outfile
    done
    echo "};" >>$outfile
done
