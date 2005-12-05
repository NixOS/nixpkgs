source $stdenv/setup

makeFlags="linux-x86"

installPhase=installPhase
installPhase() {
    ensureDir $out
    ./bin/installmesa $out
}

genericBuild
