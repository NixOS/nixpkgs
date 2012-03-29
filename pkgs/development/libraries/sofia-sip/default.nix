{ stdenv, fetchurl, glib, openssl, pkgconfig }:

stdenv.mkDerivation rec {
  name = "sofia-sip-1.12.11";

  src = fetchurl {
    url = "mirror://sourceforge/sofia-sip/${name}.tar.gz";
    sha256 = "10bwsdfijpbk9ahlfpk94kzdapxiahl9mljpgwghvq1630pbq09b";
  };

  buildInputs = [ glib openssl ];
  buildNativeInputs = [ pkgconfig ];
}
