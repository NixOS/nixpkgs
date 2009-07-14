source $stdenv/setup

ensureDir $out
cd $out
unpackFile $src
mkdir xml
mkdir xml/xsl
mv docbook-xsl-* xml/xsl/docbook
