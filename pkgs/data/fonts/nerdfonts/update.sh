#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nix-prefetch jq

latest_release=$(curl --silent https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest)
version=$(jq -r '.tag_name' <<<"$latest_release")

dirname="$(dirname "$0")"
echo \""${version#v}"\" >"$dirname/version-new.nix"
if diff -q "$dirname/version-new.nix" "$dirname/version.nix"; then
    echo No new version available, current: $version
    exit 0
else
    echo Updated to version "$version"
    mv "$dirname/version-new.nix" "$dirname/version.nix"
fi

printf '{\n' > "$dirname/shas.nix"

while
  read -r name
  read -r url
do
<<<<<<< HEAD
    printf '  "%s" = "%s";\n' "${name%%.*}" "$(nix-prefetch-url "$url")" >>"$dirname/shas.nix"
done < <(jq -r '.assets[] | select(.name | test("xz")) | .name, .browser_download_url' <<<"$latest_release")
=======
    printf '  "%s" = "%s";\n' "${name%.*}" "$(nix-prefetch-url "$url")" >>"$dirname/shas.nix"
done < <(jq -r '.assets[] | .name, .browser_download_url' <<<"$latest_release")
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

printf '}\n' >> "$dirname/shas.nix"
