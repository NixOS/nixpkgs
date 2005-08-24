source $stdenv/setup

configureFlags="--disable-x11 --disable-imlib2 --disable-doc"
export NIX_CFLAGS_COMPILE="-I$ncurses/include/ncurses -I$ncurses/include $NIX_CFLAGS_COMPILE"

genericBuild
