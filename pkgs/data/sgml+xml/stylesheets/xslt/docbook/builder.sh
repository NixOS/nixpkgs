. $stdenv/setup || exit 1

mkdir $out || exit 1
cd $out || exit 1
tar xvfz $src || exit 1
mkdir xml || exit 1
mkdir xml/xsl || exit 1
mv docbook-xsl-* xml/xsl/docbook || exit 1
