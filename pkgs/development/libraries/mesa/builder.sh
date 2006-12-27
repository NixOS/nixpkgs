source $stdenv/setup

buildFlags="linux-x86"

installPhase=installPhase
installPhase() {
    ensureDir $out
    ./bin/installmesa $out
}

genericBuild
