{ stdenv, fetchurl, openssl, pkgconfig, libgcrypt, ucommon }:

stdenv.mkDerivation {
  name = "ccrtp-2.0.6";

  src = fetchurl {
    url = mirror://gnu/ccrtp/ccrtp-2.0.6.tar.gz;
    sha256 = "06rqwk2w5sikfb3l5bcpxszhq4g7ra840gqx1f011xrmhvclrzir";
  };

  buildInputs = [ openssl pkgconfig libgcrypt ];
  propagatedBuildInputs = [ ucommon ];

  doCheck = true;

  meta = {
    description = "GNU ccRTP, an implementation of the IETF real-time transport protocol (RTP)";
    homepage = http://www.gnu.org/software/ccrtp/;
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [ marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
