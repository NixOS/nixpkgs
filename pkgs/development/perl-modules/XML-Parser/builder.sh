#! /bin/sh

buildinputs="$perl $expat"
. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd XML-Parser-* || exit 1

perl Makefile.PL EXPATLIBPATH=$expat/lib EXPATINCPATH=$expat/include \
  SITEPREFIX=$out PERLPREFIX=$out || exit 1
make || exit 1
make install || exit 1
