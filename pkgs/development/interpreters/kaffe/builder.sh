source $stdenv/setup || exit 1

configureFlags="--with-jikes=$jikes/bin/jikes --enable-pure-java-math"
genericBuild

