{ stdenv, fetchurl, openssl, pkgconfig, libgcrypt, commoncpp2 }:

stdenv.mkDerivation {
  name = "ccrtp-1.8.0";

  src = fetchurl {
    url = mirror://gnu/ccrtp/ccrtp-1.8.0.tar.gz;
    sha256 = "0wr4dandlfajhmg90nqyvwv61ikn9vdycji001310y3c4zfysprn";
  };

  buildInputs = [ openssl pkgconfig libgcrypt commoncpp2 ];

  patches = [ ./gcc-4.6-fix.patch ];

  meta = {
    description = "GNU ccRTP is an implementation of RTP, the real-time transport protocol from the IETF";
    homepage = "http://www.gnu.org/software/ccrtp/";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
