set -e
. $stdenv/setup

tar xvf $src
mkdir -p $out
mv * $out
