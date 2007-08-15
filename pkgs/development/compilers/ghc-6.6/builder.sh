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

configureFlags="--with-readline-libraries=\"$readline/lib\""

preConfigure()
{
    chmod u+x rts/gmp/configure
    # add library paths for gmp, ncurses
    sed -i "s|^\(library-dirs.*$\)|\1 \"$gmp/lib\"|" rts/package.conf.in
    sed -i "s|^\(library-dirs.*$\)|\1 \"$ncurses/lib\"|" libraries/readline/package.conf.in
}
preConfigure=preConfigure

# Standard configure/make/make install
genericBuild
