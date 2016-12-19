set -e
source $stdenv/setup

$unzip/bin/unzip $src
mkdir -p $out
mv $name*/* $out
