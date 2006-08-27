source $stdenv/setup

preConfigure() {
  autoreconf -i
}

preConfigure=preConfigure

genericBuild
