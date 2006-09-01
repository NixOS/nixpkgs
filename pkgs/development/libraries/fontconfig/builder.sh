source $stdenv/setup

configureFlags="--with-confdir=$out/etc/fonts --disable-docs"

genericBuild
