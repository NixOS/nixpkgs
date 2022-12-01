#!/usr/bin/env nix-shell
#!nix-shell -i bash -p dotnet-sdk_5 -p jq -p xmlstarlet -p curl
set -euo pipefail

cat << EOL
{ fetchurl }: [
EOL

tmpdir="$(mktemp -d -p "$(pwd)")" # must be under source root
trap 'rm -rf "$tmpdir"' EXIT

HOME="$tmpdir" dotnet msbuild -t:restore -p:Configuration=Release -p:RestorePackagesPath="$tmpdir"/.nuget/packages \
        -p:RestoreNoCache=true -p:RestoreForce=true \
        src/NuGet/Microsoft.Net.Compilers.Toolset/Microsoft.Net.Compilers.Toolset.Package.csproj >&2

mapfile -t repos < <(
    xmlstarlet sel -t -v 'configuration/packageSources/add/@value' -n NuGet.config "$tmpdir"/.nuget/NuGet/NuGet.Config |
        while IFS= read index
        do
            curl --compressed -fsL "$index" | \
                jq -r '.resources[] | select(."@type" == "PackageBaseAddress/3.0.0")."@id"'
        done
)

cd "$tmpdir/.nuget/packages"
for package in *
do
    cd "$package"
    for version in *
    do
        found=false
        for repo in "${repos[@]}"
        do
            url="$repo$package/$version/$package.$version.nupkg"
            if curl -fsL "$url" -o /dev/null
            then
                found=true
                break
            fi
        done

        if ! $found
        then
            echo "couldn't find $package $version" >&2
            exit 1
        fi

        sha256=$(nix-prefetch-url "$url" 2>/dev/null)
        cat << EOL
  {
    pname = "$package";
    version = "$version";
    src = fetchurl {
      url = "$url";
      sha256 = "$sha256";
    };
  }
EOL
    done
    cd ..
done

cat << EOL
]
EOL
