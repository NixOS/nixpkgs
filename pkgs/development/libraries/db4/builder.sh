source $stdenv/setup

preConfigure() {
    cd build_unix
    configureScript=../dist/configure
}

postInstall() {
    rm -rf $out/docs
}

genericBuild
