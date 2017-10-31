{stdenv, fetchurl, xmlto, docbook_xml_dtd_412, docbook_xsl, libxml2 }:

stdenv.mkDerivation {
  name = "giflib-5.1.4";
  src = fetchurl {
    url = mirror://sourceforge/giflib/giflib-5.1.4.tar.bz2;
    sha256 = "1md83dip8rf29y40cm5r7nn19705f54iraz6545zhwa6y8zyq9yz";
  };

  buildInputs = [ xmlto docbook_xml_dtd_412 docbook_xsl libxml2 ];
  meta = {
    description = "A library for reading and writing gif images";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
    branch = "5.1";
  };
}
