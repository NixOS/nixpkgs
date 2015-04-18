
source $stdenv/setup

unpackPhase
cd $sourceRoot

install -dm 755 $out/include/cimg $out/share/doc/cimg/html $out/share/cimg/examples $out/share/cimg/plugins

install -m 644 CImg.h $out/include/cimg
cp -dr --no-preserve=ownership html/* $out/share/doc/cimg/html/
cp -dr --no-preserve=ownership examples/* $out/share/cimg/examples/
cp -dr --no-preserve=ownership plugins/* $out/share/cimg/plugins/
