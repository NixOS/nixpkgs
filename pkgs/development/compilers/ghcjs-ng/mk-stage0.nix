{ configuredSrc
, runCommand
, cabal2nix
, yq
}:

runCommand "stage0.nix" {
  buildInputs = [cabal2nix yq];
} ''
  (
    printf '{ callPackage, configuredSrc }:\n\n{\n\n'
    yq '.packages | .[]' ${configuredSrc}/stack.yaml -r | sed 's|^\.$|./.|' | sed 's|^\.||' | while read f; do
      printf '  %s = callPackage\n' \
        "$(find ${configuredSrc}/$f -name "*.cabal" -maxdepth 1 \
          | xargs basename \
          | sed 's/.cabal$//')"
      printf '(%s) {};' \
        "$(cabal2nix ${configuredSrc}/$f \
          | sed 's|${configuredSrc}/|configuredSrc + |g')" \
        | sed 's/^/    /'
      printf '\n\n'
    done
    printf '}\n'
  ) > $out
''
