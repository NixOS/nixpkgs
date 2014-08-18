{ fetchurl, stdenv, gnutls, pkgconfig, zlib, libgcrypt }:

stdenv.mkDerivation rec {
  name = "ucommon-6.0.7";

  src = fetchurl {
    url = mirror://gnu/commoncpp/ucommon-6.0.7.tar.gz;
    sha256 = "1rlvchmg6qq8jq79qjgv0l0wqi1dqhmm4ng1qj9f012dbhwcap3x";
  };

  buildInputs = [ pkgconfig gnutls zlib ];

  # Propagate libgcrypt because it appears in `ucommon.pc'.
  propagatedBuildInputs = [ libgcrypt ];

  doCheck = true;

  meta = {
    description = "GNU uCommon C++, C++ library to facilitate using C++ design patterns";
    homepage = http://www.gnu.org/software/commoncpp/;
    license = "LGPLv3+";

    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = stdenv.lib.platforms.all;
  };
}
