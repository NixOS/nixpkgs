source $stdenv/setup

preConfigure() {
    # Workarounds for the ancient libtool shipped by libjpeg.
    ln -s $libtool/bin/libtool .
    cp $libtool/share/libtool/config.guess .
    cp $libtool/share/libtool/config.sub .
}

preInstall() {
    mkdir $out
    mkdir $out/bin
    mkdir $out/lib
    mkdir $out/include
    mkdir $out/man
    mkdir $out/man/man1
}

patchPhase() {
    for i in $patches; do
	patch < $i
    done
}

genericBuild
