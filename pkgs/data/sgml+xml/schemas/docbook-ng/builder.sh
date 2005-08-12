. $stdenv/setup

mkdir -p $out/xml/rng/docbook
cd $out/xml/rng/docbook
cp $rng   docbook.rng
cp $rnc   docbook.rnc
cp $xirng docbookxi.rng
cp $xirnc docbookxi.rnc

mkdir -p $out/xml/dtd/docbook
cd $out/xml/dtd/docbook
cp $dtd   docbook.dtd
cp $xidtd docbookxi.dtd
