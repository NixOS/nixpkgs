source $stdenv/setup

buildFlags="all so sobin"
installFlags="soinstall INSTALL_ROOT=$out"

genericBuild
