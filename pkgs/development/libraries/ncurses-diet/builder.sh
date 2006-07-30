source $stdenv/setup

configureFlags="--includedir=$out/include --without-cxx-binding"

genericBuild
