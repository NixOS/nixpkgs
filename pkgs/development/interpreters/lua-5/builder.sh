source $stdenv/setup

makeFlags="all so sobin"
installFlags="soinstall INSTALL_ROOT=$out"

genericBuild
