buildinputs="$perl $libxml2 $libxslt"
. $stdenv/setup || exit 1

export PERL5LIB=$perlXMLParser/lib/site_perl:$PERL5LIB

tar xvfz $src || exit 1
cd scrollkeeper-* || exit 1
./configure --prefix=$out \
  --with-xml-catalog=$docbook_xml_dtd/xml/dtd/docbook/docbook.cat \
  || exit 1
make || exit 1
make install || exit 1
strip -S $out/lib/*.a || exit 1
