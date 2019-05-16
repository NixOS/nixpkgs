{ stdenv, fetchurl, pkgconfig, ucommon, openssl, libgcrypt }:

stdenv.mkDerivation rec {
  name = "ccrtp-2.1.2";

  src = fetchurl {
    url = "mirror://gnu/ccrtp/${name}.tar.gz";
    sha256 = "17ili8l7zqbbkzr1rcy4hlnazkf50mds41wg6n7bfdsx3c7cldgh";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ ucommon openssl libgcrypt ];

  configureFlags = [
    "--disable-demos"
  ];

  doCheck = true;

  meta = {
    description = "An implementation of the IETF real-time transport protocol (RTP)";
    homepage = https://www.gnu.org/software/ccrtp/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
