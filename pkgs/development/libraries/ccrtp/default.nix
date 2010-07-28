{ stdenv, fetchurl, openssl, pkgconfig, libgcrypt, commoncpp2 }:

stdenv.mkDerivation {
  name = "ccrtp-1.7.1";

  src = fetchurl {
    url = mirror://gnu/ccrtp/ccrtp-1.7.1.tar.gz;
    sha256 = "0psi91r0fgawpa5x4jiq7lkr180agdi25gi0mfriqcmykxg7r1jn";
  };

  buildInputs = [ openssl pkgconfig libgcrypt commoncpp2 ];

  meta = { 
    description = "GNU ccRTP is an implementation of RTP, the real-time transport protocol from the IETF";
    homepage = "http://www.gnu.org/software/ccrtp/";
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
