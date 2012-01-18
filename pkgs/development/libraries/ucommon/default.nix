{ fetchurl, stdenv, gnutls, pkgconfig, zlib, libgcrypt }:

stdenv.mkDerivation rec {
  name = "ucommon-5.1.2";

  src = fetchurl {
    url = mirror://gnu/commoncpp/ucommon-5.1.2.tar.gz;
    sha256 = "1a6wfvrqpkk4w3l33jx5bdj38ljlyr92041aakvwmajpkczjf2q3";
  };

  buildInputs = [ pkgconfig gnutls zlib ];

  # Propagate libgcrypt because it appears in `ucommon.pc'.
  propagatedBuildInputs = [ libgcrypt ];

  doCheck = true;

  meta = {
    description = "GNU uCommon C++, C++ library to facilitate using C++ design patterns";
    homepage = http://www.gnu.org/software/commoncpp/;
    license = "LGPLv3+";

    maintainers = with stdenv.lib.maintainers; [ viric ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}
