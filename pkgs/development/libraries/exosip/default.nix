{stdenv, fetchurl, libosip, openssl, pkgconfig }:

stdenv.mkDerivation rec {
 name = "libexosip2-${version}";
 version = "4.1.0";
 
 src = fetchurl {
    url = "mirror://savannah/exosip/libeXosip2-${version}.tar.gz";
    sha256 = "17cna8kpc8nk1si419vgr6r42k2lda0rdk50vlxrw8rzg0xp2xrw";
  };
 
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libosip openssl pkgconfig ];
      
  meta = with stdenv.lib; {
    license = licenses.gpl2Plus;
    description = "Library that hides the complexity of using the SIP protocol";
    platforms =platforms.linux;
  };
}
