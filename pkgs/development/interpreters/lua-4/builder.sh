source $stdenv/setup

buildFlags="all so sobin"
installFlags="INSTALL_ROOT=$out"

genericBuild
