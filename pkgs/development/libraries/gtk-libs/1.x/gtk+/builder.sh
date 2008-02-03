source $stdenv/setup
genericBuild

if test -n "$_propagatedBuildInputs"; then
    if ! test -x $out/nix-support; then mkdir $out/nix-support; fi
    echo "$_propagatedBuildInputs" > $out/nix-support/propagated-build-inputs
fi
