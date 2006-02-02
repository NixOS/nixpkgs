source $stdenv/setup

makeFlags="all so sobin"
installFlags="INSTALL_ROOT=$out"

genericBuild
