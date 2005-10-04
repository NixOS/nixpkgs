source $stdenv/setup

configureFlags="--without-x --with-ncurses=$ncurses"

genericBuild
