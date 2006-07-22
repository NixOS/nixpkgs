source $stdenv/setup

configureFlags="--with-tcl=$tcl/lib"
preConfigure() {
  cd unix
}

preConfigure=preConfigure

genericBuild
