source $stdenv/setup

configureFlags="--enable-shared"

preInstall() {
    mkdir $out
    mkdir $out/bin
    mkdir $out/lib
    mkdir $out/include
    mkdir $out/man
    mkdir $out/man/man1
}
preInstall=preInstall

genericBuild