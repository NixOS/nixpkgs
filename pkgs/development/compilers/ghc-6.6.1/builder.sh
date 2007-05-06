source $stdenv/setup

# Setup isolated package management
postInstall()
{
    ensureDir "$out/nix-support"
    echo "# Path to the GHC compiler directory in the store" > $out/nix-support/setup-hook
    echo "ghc=$out" >> $out/nix-support/setup-hook
    echo ""         >> $out/nix-support/setup-hook
    cat $setupHook  >> $out/nix-support/setup-hook
}
postInstall=postInstall

preConfigure()
{
    chmod u+x rts/gmp/configure
}
preConfigure=preConfigure

# Standard configure/make/make install
genericBuild
