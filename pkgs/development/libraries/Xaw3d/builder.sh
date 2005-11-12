source $stdenv/setup

configurePhase=configurePhase
configurePhase() {
    cd lib/Xaw3d
    (mkdir X11 && cd X11 && ln -fs .. Xaw3d)
    xmkmf
}

buildPhase=buildPhase
buildPhase() {
    make depend $makeFlags
    make $makeFlags
}

installPhase() {
    make install SHLIBDIR=$out/lib USRLIBDIR=$out/lib INCDIR=$out/include
}

makeFlags="CDEBUGFLAGS=" # !!! awful hack

genericBuild