source $stdenv/setup

unpackFile $src

cd docbook-*

mkdir -p $out/xml/rng
cp -prv rng $out/xml/rng/docbook

mkdir -p $out/xml/dtd
cp -prv dtd $out/xml/dtd/docbook

mkdir -p $out/share/doc
cp -prv docs $out/share/doc/docbook

mkdir -p $out/share/docbook
cp -prv tools $out/share/docbook/
