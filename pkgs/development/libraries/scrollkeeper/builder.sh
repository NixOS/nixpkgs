. $stdenv/setup

export PERL5LIB=$perlXMLParser/lib/site_perl:$PERL5LIB

configureFlags="--with-xml-catalog=$docbook_xml_dtd_42/xml/dtd/docbook/docbook.cat"

genericBuild
