source $stdenv/setup

tar zxf $src
cd man-pages-*

sed -e "s#^MANDIR=.*#MANDIR=$out/share/man#" Makefile > Makefile.tmp
mv Makefile.tmp Makefile

make install
