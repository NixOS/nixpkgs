{ stdenv, fetchurl, perl, libxml2, libxslt, docbook_xml_dtd
, perlXMLParser}:

assert perl != null && libxml2 != null && libxslt != null
  && docbook_xml_dtd != null && perlXMLParser != null;

# !!! seems to need iconv, but cannot find it since $glibc/bin is not in PATH

stdenv.mkDerivation {
  name = "scrollkeeper-0.3.14";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/scrollkeeper/scrollkeeper-0.3.14.tar.gz;
    md5 = "161eb3f29e30e7b24f84eb93ac696155";
  };
  buildInputs = [perl libxml2 libxslt];
  inherit docbook_xml_dtd perlXMLParser;
}
