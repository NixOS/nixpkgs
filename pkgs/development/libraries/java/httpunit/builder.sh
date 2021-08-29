source $stdenv/setup

$unzip/bin/unzip $src
mkdir $out
mv $name/* $out/
