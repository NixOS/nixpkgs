{ stdenv, fetchurl, openssl, pkgconfig, libgcrypt, ucommon }:

stdenv.mkDerivation {
  name = "ccrtp-2.0.9";

  src = fetchurl {
    url = mirror://gnu/ccrtp/ccrtp-2.0.9.tar.gz;
    sha256 = "1prh2niwa4lzvskk12j4ckr7dv141dfh8yjmpkbhbnv4gmpifci0";
  };

  buildInputs = [ openssl pkgconfig libgcrypt ];
  propagatedBuildInputs = [ ucommon ];

  doCheck = true;

  meta = {
    description = "An implementation of the IETF real-time transport protocol (RTP)";
    homepage = http://www.gnu.org/software/ccrtp/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
