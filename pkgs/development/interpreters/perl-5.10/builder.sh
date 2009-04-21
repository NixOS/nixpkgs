source $stdenv/setup

configureFlags="$configureFlags -Dman1dir=$out/share/man/man1 -Dman3dir=$out/share/man/man3"

if test "$NIX_ENFORCE_PURITY" = "1"; then
    GLIBC=$(cat $NIX_GCC/nix-support/orig-libc)
    configureFlags="$configureFlags -Dlocincpth=$GLIBC/include -Dloclibpth=$GLIBC/lib"
fi

configureScript=./Configure
dontAddPrefix=1

preBuild() {
    # Make Cwd work on NixOS (where we don't have a /bin/pwd).
    substituteInPlace lib/Cwd.pm --replace "'/bin/pwd'" "'$(type -tP pwd)'"
}

genericBuild
