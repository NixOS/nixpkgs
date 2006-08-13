source $stdenv/setup

preConfigure() {
  autoconf
}

preConfigure=preConfigure

genericBuild
