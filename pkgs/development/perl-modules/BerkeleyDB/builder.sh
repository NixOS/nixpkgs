#! /bin/sh

buildinputs="$perl $db4"
. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd BerkeleyDB-* || exit 1

echo "LIB = $db4/lib" > config.in
echo "INCLUDE = $db4/include" >> config.in

perl Makefile.PL || exit 1
make || exit 1
make install SITEPREFIX=$out PERLPREFIX=$out || exit 1
