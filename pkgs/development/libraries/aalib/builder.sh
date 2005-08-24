source $stdenv/setup

configureFlags="--without-x --with-ncurses=$ncurses"
export NIX_CFLAGS_COMPILE="-I$ncurses/include/ncurses $NIX_CFLAGS_COMPILE"

genericBuild
