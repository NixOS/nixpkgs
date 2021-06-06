set -e
source $stdenv/setup

tar zxvf $src
mkdir -p $out
mv $name/* $out
