#! /bin/sh -e

buildinputs="$freetype $expat $x11 $ed"
. $stdenv/setup

# Fontconfig generates a bad `fonts.conf' file is the timezone is not known
# (because it calls `date').
export TZ=UTC

tar xvfz $src
cd fontconfig-*
./configure --prefix=$out --with-confdir=$out/etc/fonts \
 --x-includes=$x11/include --x-libraries=$x11/lib \
 --with-expat-includes=$expat/include --with-expat-lib=$expat/lib
make
make install

mkdir $out/nix-support
echo "$freetype" > $out/nix-support/propagated-build-inputs
