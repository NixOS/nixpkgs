{stdenv, fetchurl, xmlto, docbook_xml_dtd_412, docbook_xsl, libxml2 }:

stdenv.mkDerivation {
  name = "giflib-5.0.6";
  src = fetchurl {
    url = mirror://sourceforge/giflib/giflib-5.0.6.tar.bz2;
    sha256 = "1sk9ysh27nabwb6z7a38n8gy2y2rnl3vjkbapv7pbjnzrff862c9";
  };

  buildInputs = [ xmlto docbook_xml_dtd_412 docbook_xsl libxml2 ];
  meta = {
    description = "giflib is a library for reading and writing gif images";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
    branch = "5.0";
  };
}
