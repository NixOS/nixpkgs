{ stdenv, fetchurl, openssl, pkgconfig, libgcrypt, ucommon }:

stdenv.mkDerivation {
  name = "ccrtp-2.0.2";

  src = fetchurl {
    url = mirror://gnu/ccrtp/ccrtp-2.0.2.tar.gz;
    sha256 = "1n42nscqwryz9f0jpg8lnv22x9m8mzr6rqir9cvbgm1r2skwjh4f";
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
