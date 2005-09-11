set -e
. $stdenv/setup

tar zxvf $src
mkdir -p $out
mv $name/* $out
