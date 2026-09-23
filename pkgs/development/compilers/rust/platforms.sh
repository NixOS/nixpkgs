#!/usr/bin/env nix
#! nix shell --impure --expr ``
#! nix with import ../../../.. { };
#! nix [
#! nix   bash
#! nix   jq
#! nix   rust.packages.prebuilt.rustc-unwrapped
#! nix ]
#! nix ``
#! nix --command bash
set -euo pipefail

script=$(readlink -f "${BASH_SOURCE[0]}")
repo_root=$(git -C "$(dirname "$script")" rev-parse --show-toplevel)

cd "$repo_root"

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

rust_targets="$tmpdir/rust-targets.json"
nix_platforms="$tmpdir/nix-platforms.json"
supported_platforms="$tmpdir/supported-platforms.json"
generated_platforms="$tmpdir/platforms.json"
platforms_json="pkgs/development/compilers/rust/platforms.json"

RUSTC_BOOTSTRAP=1 rustc -Z unstable-options \
    --print all-target-specs-json > "$rust_targets"

nix eval --json --impure --expr '
  let
    lib = import ./lib;
  in
  map (
    system:
    let
      platform = lib.systems.elaborate system;
    in
    {
      inherit system;
      rustcTargetSpec = platform.rust.rustcTargetSpec;
    }
  ) lib.systems.doubles.all
' > "$nix_platforms"

jq --slurpfile targets "$rust_targets" '
  [
    .[] as $platform
    | select($targets[0] | has($platform.rustcTargetSpec))
    | $platform + {
        metadata: $targets[0][$platform.rustcTargetSpec].metadata
      }
    | select(.metadata.tier != null)
  ]
  | sort_by(.system)
' "$nix_platforms" > "$supported_platforms"

missing_platforms=$(
    jq -r --slurpfile targets "$rust_targets" '
      .[] as $platform
      | select(($targets[0] | has($platform.rustcTargetSpec)) | not)
      | "  \($platform.system) -> \($platform.rustcTargetSpec)"
    ' "$nix_platforms"
)

if [[ -n $missing_platforms ]]; then
    printf '%s\n%s\n' \
        "Skipping Nix platforms without matching built-in Rust targets:" \
        "$missing_platforms" >&2
fi

jq '
  {
    targetPlatformsWithHostTools: [
      .[]
      | select(.metadata.host_tools == true)
      | .system
    ],
    targetPlatformsWithoutHostTools: [
      .[]
      | select(.metadata.host_tools != true)
      | .system
    ]
  }
' "$supported_platforms" > "$generated_platforms"

mv "$generated_platforms" "$platforms_json"
