#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nix-prefetch jq
# shellcheck shell=bash

latest_release=$(curl --silent https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest)
version=$(jq -r '.tag_name' <<<"$latest_release")

dirname="$(dirname "$0")"
echo \""${version#v}"\" >"$dirname/version.nix"

echo Using version "$version"

printf '{\n' > "$dirname/shas.nix"

while
  read -r name
  read -r url
do
    printf '  "%s" = "%s";\n' "${name%.*}" "$(nix-prefetch-url "$url")" >>"$dirname/shas.nix"
done < <(jq -r '.assets[] | .name, .browser_download_url' <<<"$latest_release")

printf '}\n' >> "$dirname/shas.nix"
