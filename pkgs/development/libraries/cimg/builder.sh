
source $stdenv/setup

unpackPhase
cd $sourceRoot

install -dm 755 $out/include/cimg $doc/share/doc/cimg/html $doc/share/cimg/examples $doc/share/cimg/plugins

install -m 644 CImg.h $out/include/cimg
cp -dr --no-preserve=ownership examples/* $doc/share/cimg/examples/
cp -dr --no-preserve=ownership plugins/* $doc/share/cimg/plugins/
