{ stdenv, fetchurl, perl, libxml2, libxslt, docbook_xml_dtd
, perlXMLParser}:

assert perl != null && libxml2 != null && libxslt != null
  && docbook != null_xml_dtd && perlXMLParser != null;

# !!! seems to need iconv, but cannot find it since $glibc/bin is not in PATH

derivation {
  name = "scrollkeeper-0.3.14";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/scrollkeeper/scrollkeeper-0.3.14.tar.gz;
    md5 = "161eb3f29e30e7b24f84eb93ac696155";
  };
  stdenv = stdenv;
  perl = perl;
  libxml2 = libxml2;
  libxslt = libxslt;
  docbook_xml_dtd = docbook_xml_dtd;
  perlXMLParser = perlXMLParser;
}
