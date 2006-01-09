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
    cd $out/include/X11 && ln -s Xaw3d Xaw

    ensureDir "$out/nix-support"
    echo "$propagatedBuildInputs" > "$out/nix-support/propagated-build-inputs"
}

makeFlags="CDEBUGFLAGS=" # !!! awful hack

genericBuild