{ stdenv, fetchurl, glib, openssl, pkgconfig }:

stdenv.mkDerivation rec {
  name = "sofia-sip-1.12.11";

  src = fetchurl {
    url = "mirror://sourceforge/sofia-sip/${name}.tar.gz";
    sha256 = "10bwsdfijpbk9ahlfpk94kzdapxiahl9mljpgwghvq1630pbq09b";
  };

  buildInputs = [ glib openssl ];
  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "Open-source SIP User-Agent library, compliant with the IETF RFC3261 specification";
    homepage = http://sofia-sip.sourceforge.net/;
    platforms = platforms.linux;
    license = licenses.lgpl2;
  };
}
