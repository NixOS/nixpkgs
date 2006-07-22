source $stdenv/setup

preConfigure() {
  cd unix
}

preConfigure=preConfigure

genericBuild
