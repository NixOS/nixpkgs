{stdenv, fetchurl, libosip, openssl, pkgconfig }:

stdenv.mkDerivation rec {
  version = "3.6.0";
  src = fetchurl {
    url = "mirror://savannah/exosip/libeXosip2-${version}.tar.gz";
    sha256 = "0r1mj8x5991bgwf03bx1ajn5kbbmw1136jabw2pn7dls9h41mnli";
  };
  name = "libexosip2-${version}";

  buildInputs = [ libosip openssl pkgconfig ];
      
  meta = {
    license = stdenv.lib.licenses.gpl2Plus;
    description = "Library that hides the complexity of using the SIP protocol";
    platforms = stdenv.lib.platforms.linux;
  };
}
