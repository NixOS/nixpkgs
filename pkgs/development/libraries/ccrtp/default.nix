{ stdenv, fetchurl, openssl, pkgconfig, libgcrypt, ucommon }:

stdenv.mkDerivation {
  name = "ccrtp-2.0.0";

  src = fetchurl {
    url = mirror://gnu/ccrtp/ccrtp-2.0.0.tar.gz;
    sha256 = "1gx3jsywvihwkhk69xkcpq2plb6lbylpz0gpg55c5dx7xg1796b2";
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
