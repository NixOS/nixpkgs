{ stdenv, fetchurl, openssl, pkgconfig, libgcrypt, commoncpp2 }:

stdenv.mkDerivation {
  name = "ccrtp-1.7.2";

  src = fetchurl {
    url = mirror://gnu/ccrtp/ccrtp-1.7.2.tar.gz;
    sha256 = "1vz759f0342ih95sc7vmzx8als7y2ddr0s3jaaj03x22r7xaqzwy";
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
