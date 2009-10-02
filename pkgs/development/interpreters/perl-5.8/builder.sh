source $stdenv/setup

if test "$NIX_ENFORCE_PURITY" = "1"; then
    case $system in
        *-linux)  LIBC=$(cat $NIX_GCC/nix-support/orig-libc) ;;
        *-darwin) LIBC=/usr ;;
        *)        echo unsupported system $system; exit 1 ;;
    esac
    extraflags="-Dlocincpth=$LIBC/include -Dloclibpth=$LIBC/lib"
fi

configureScript=./Configure
configureFlags="-de -Dcc=gcc -Dprefix=$out -Uinstallusrbinperl $extraflags"
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
