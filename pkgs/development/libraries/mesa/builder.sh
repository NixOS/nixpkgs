. $stdenv/setup

makeFlags="linux-x86"

installPhase=installPhase
installPhase() {
    mkdir $out
    mkdir $out/lib
    cp -pvd lib/* $out/lib
    mkdir $out/include
    cp -rv include/GL $out/include
}

genericBuild
