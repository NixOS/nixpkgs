#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nix-prefetch jq

dirname="$(dirname "$0")"
releases=$(curl --silent https://api.github.com/repos/ryanoasis/nerd-fonts/releases)

update () {
  unstable=$1

  [[ $unstable = true ]] && start="" || start="map(select(.prerelease == false)) | "
  version=$(jq -r "${start}first | .tag_name" <<<"$releases")

  [[ $unstable = true ]] && fname="-unstable" || fname=""

  echo \""${version}"\" >"$dirname/version${fname}.nix"

  echo Using version "$version"

  printf '{\n' > "$dirname/shas${fname}.nix"

  while
    read -r name
    read -r url
  do
      printf '  "%s" = "%s";\n' "${name%.*}" "$(nix-prefetch-url "$url")" >>"$dirname/shas${fname}.nix"
  done < <(jq -r "map(select( .tag_name == \"$version\" )) | first | .assets[] | .name, .browser_download_url" <<<"$releases")

  printf '}\n' >> "$dirname/shas${fname}.nix"
}

update false
update true
