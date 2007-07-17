source $stdenv/setup

ensureDir $out/nix-support
substitute "$hook" "$out/nix-support/setup-hook" --subst-var out

# !!! TODO: -system-libmng
configureFlags="-prefix $out $configureFlags"

genericBuild
