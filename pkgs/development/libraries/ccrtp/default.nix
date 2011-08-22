{ stdenv, fetchurl, openssl, pkgconfig, libgcrypt, ucommon }:

stdenv.mkDerivation {
  name = "ccrtp-2.0.1";

  src = fetchurl {
    url = mirror://gnu/ccrtp/ccrtp-2.0.1.tar.gz;
    sha256 = "0wksiq55zq8yvjgzkaxyg15w9kfr4sni8a0yqk11qdqpl8x0al9x";
  };

  buildInputs = [ openssl pkgconfig libgcrypt ucommon ];

  doCheck = true;

  meta = {
    description = "GNU ccRTP, an implementation of the IETF real-time transport protocol (RTP)";
    homepage = http://www.gnu.org/software/ccrtp/;
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [ marcweber ludo ];
    platforms = stdenv.lib.platforms.linux;
  };
}
