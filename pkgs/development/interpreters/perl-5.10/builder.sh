source $stdenv/setup

if test "$NIX_ENFORCE_PURITY" = "1"; then
    GLIBC=$(cat $NIX_GCC/nix-support/orig-libc)
    extraflags="-Dlocincpth=$GLIBC/include -Dloclibpth=$GLIBC/lib"
fi

configureScript=./Configure
configureFlags="-de -Dcc=gcc -Dprefix=$out -Dman1dir=$out/share/man/man1 -Dman3dir=$out/share/man/man3 -Uinstallusrbinperl $extraflags"
dontAddPrefix=1

preBuild() {
    # Make Cwd work on NixOS (where we don't have a /bin/pwd).
    substituteInPlace lib/Cwd.pm --replace "'/bin/pwd'" "'$(type -tP pwd)'"
}

postInstall() {
    ensureDir "$out/nix-support"
    cp $setupHook $out/nix-support/setup-hook
}

genericBuild
