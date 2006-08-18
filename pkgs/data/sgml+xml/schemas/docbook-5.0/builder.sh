source $stdenv/setup

unpackFile $src

cd docbook-*

ensureDir $out/xml/rng
cp -prv rng $out/xml/rng/docbook

ensureDir $out/xml/dtd
cp -prv dtd $out/xml/dtd/docbook

ensureDir $out/share/doc
cp -prv docs $out/share/doc/docbook

ensureDir $out/share/docbook
cp -prv tools $out/share/docbook/
