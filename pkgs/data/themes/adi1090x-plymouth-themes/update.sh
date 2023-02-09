#!/usr/bin/env nix-shell
#! nix-shell -i bash --keep GITHUB_TOKEN -p nix-prefetch jq

set -eo pipefail

curl_args=( '--silent' )

# optionally takes a GITHUB_TOKEN to overcome api rate limiting.
if [ -n "$GITHUB_TOKEN" ]; then curl_args+=( --header "authorization: Bearer ${GITHUB_TOKEN}" ); fi

# get last master ref
curl_args+=( --url https://api.github.com/repos/adi1090x/files/commits/master )
last_ref=$(curl "${curl_args[@]}" | jq -r '.sha' )

unset curl_args[-1]
curl_args+=( https://api.github.com/repos/adi1090x/files/git/trees/$last_ref\?recursive=1 )

theme_archives=$(curl "${curl_args[@]}" \
  | jq '.tree | map(select(.path| test("^plymouth-themes/themes/pack_.*tar.gz$"))| .path)')

dirname="$(dirname "$0")"

printf '{\n' > "$dirname/shas.nix"

repo_url="https://github.com/adi1090x/files/raw/$last_ref"

while
  read -r file_path
do
    name=$(basename $file_path)
    printf '  "%s" = {\n    url = "%s";\n    sha = "%s";\n  };\n' "${name%%.*}" "$repo_url/$file_path" "$(nix-prefetch-url "$repo_url/$file_path")" >>"$dirname/shas.nix"
done < <(jq -r '.[]' <<<"$theme_archives")

printf '}\n' >> "$dirname/shas.nix"
