source $stdenv/setup

ensureDir $out/xml/dtd/docbook

cd $out/xml/dtd/docbook
unpackFile $src
mv docbook-*/* .
rmdir docbook-*