{ stdenv, fetchurl, openssl, pkgconfig, libgcrypt, ucommon }:

stdenv.mkDerivation {
  name = "ccrtp-2.0.3";

  src = fetchurl {
    url = mirror://gnu/ccrtp/ccrtp-2.0.3.tar.gz;
    sha256 = "1p4zzqn02zvnyjy84khiq8v65pl422fb6ni946h9sxh4yw2lgn01";
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
