. $stdenv/setup

if test "$NIX_ENFORCE_PURITY" = "1" -a -n "$NIX_STORE"; then
    GLIBC=$(cat $NIX_GCC/nix-support/orig-glibc)
    extraflags="-Dlocincpth=$GLIBC/include -Dloclibpth=$GLIBC/lib"
fi

configureScript=./Configure
configureFlags="-de -Dcc=gcc -Dprefix=$out -Uinstallusrbinperl $extraflags"
dontAddPrefix=1

postInstall() {
    ensureDir "$out/nix-support"
    cp $setupHook $out/nix-support/setup-hook
}
postInstall=postInstall

genericBuild