source $stdenv/setup

mkdir -p $out
cd $out
unpackFile $src
mkdir xml
mkdir xml/xsl
mv docbook-xsl-* xml/xsl/docbook
