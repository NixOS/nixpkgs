source $stdenv/setup

unpackCmd="tar xvfj $src"

makeFlags="-f Makefile.simple CC=gcc LD=gcc INSTALLPREFIX=$out"

postConfigure=postConfigure
postConfigure() {
    cd src
}

preInstall=preInstall
preInstall() {
    mkdir $out
    mkdir $out/lib
    mkdir $out/include
}

installFlags=$makeFlags

genericBuild