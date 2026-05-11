#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash -p nix jq yq
set -euo pipefail

src=$(nix-build . -A python3Packages.reflex.src --no-out-link)
# echo >&2 "src=$src"; exit 0 # DEBUG

declare -a workspace_paths=( "$src"/packages/* )
# printf >&2 "%s\n" "${workspace_paths[@]}"; exit 0 # DEBUG

declare -a workspaces=( "${workspace_paths[@]##*/}" )
# printf >&2 "%s\n" "${workspaces[@]}"; exit 0 # DEBUG

workspaces_json=$( printf '"%s"\n' "${workspaces[@]}" | jq -s '.' -c )

for workspace in "${workspaces[@]}"; do
  echo "$workspace.dependencies = ["
  tomlq <"$src/packages/$workspace/pyproject.toml" \
    --argjson "workspaces" "$workspaces_json" \
    '.project.dependencies + (.tool.hatch.build.hooks."reflex-pyi".dependencies // [])
      | map( split("[ !><=]"; null)[0] ) # remove ">= 1.2.3"
      | map( gsub("_"; "-") )            # normalize attrpath/pname
      | unique[]
      | if (. as $dep | $workspaces|index($dep) != null) then
          "  subPkgs.\(.)"
        elif . == "reflex" then
          "  finalAttrs.finalPackage # reflex"
        else
          "  \(.)"
        end
    ' -r
  echo '];'
done
