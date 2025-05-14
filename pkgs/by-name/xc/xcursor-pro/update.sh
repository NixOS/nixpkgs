#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nix-prefetch jq

latest_release=$(curl --silent https://api.github.com/repos/ful1e5/XCursor-pro/releases/latest)
version=$(jq -r '.tag_name' <<<"$latest_release")
version="${version#*v}"

dirname="$(dirname "$0")"
if [ "$UPDATE_NIX_OLD_VERSION" = "$version" ]; then
    printf 'No new version available, current: %s\n' $version
    exit 0
else
    printf 'Updated to version %s\n' $version
    sed -i "s/version = \"$UPDATE_NIX_OLD_VERSION\"/version = \"$version\"/" "$dirname/package.nix"
fi

printf '{\n' > "$dirname/sources.nix"

while
  read -r name
  read -r url
do
    variant="${name#*-*-}"
    variant="${variant%%.*}"

    {
        printf '  %s = {\n' "$variant"
        printf '    url = \"%s\";\n' "$url"
        printf '    sha256 = \"%s\";\n' "$(nix-prefetch-url "$url")"
        printf '  };\n'
    } >> "$dirname/sources.nix"
done < <(jq -r '.assets[] |
                select(.name | endswith(".tar.xz") and (contains("all") | not)) |
                .name, .browser_download_url' <<<"$latest_release")

printf '}\n' >> "$dirname/sources.nix"
