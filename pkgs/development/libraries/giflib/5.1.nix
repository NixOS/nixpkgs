{stdenv, fetchurl, xmlto, docbook_xml_dtd_412, docbook_xsl, libxml2 }:

stdenv.mkDerivation {
  name = "giflib-5.1.0";
  src = fetchurl {
    url = mirror://sourceforge/giflib/giflib-5.1.0.tar.bz2;
    sha256 = "06wd32akyawppar9mqdvyhcw47ssdfcj39lryim2w4v83i7nkv2s";
  };

  buildInputs = [ xmlto docbook_xml_dtd_412 docbook_xsl libxml2 ];
  meta = {
    description = "giflib is a library for reading and writing gif images";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
    branch = "5.1";
  };
}
