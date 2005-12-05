source $stdenv/setup

preConfigure() {
    cd build_unix
    configureScript=../dist/configure
}
preConfigure=preConfigure

postInstall() {
    rm -rf $out/docs
}
postInstall=postInstall

genericBuild
