. $stdenv/setup

unpackCmd="tar xvfj $src"

makeFlags="CC=gcc LD=gcc INSTALLPREFIX=$out"

preInstall() {
    mkdir $out
    mkdir $out/lib
    mkdir $out/include
}
preInstall=preInstall

installFlags=$makeFlags

genericBuild