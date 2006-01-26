source $stdenv/setup

preConfigure=preConfigure
preConfigure() {
    ./autogen.sh
}

genericBuild