. $stdenv/setup

makeFlags="-f scripts/makefile.linux"

preInstall() {
    mkdir $out
    mkdir $out/bin
    mkdir $out/lib
    mkdir $out/include
}
preInstall=preInstall

installFlags="-f scripts/makefile.linux install prefix=$out"

genericBuild