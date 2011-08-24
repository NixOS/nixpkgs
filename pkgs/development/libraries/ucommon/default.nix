{ fetchurl, stdenv, gnutls, pkgconfig, zlib, libgcrypt }:

stdenv.mkDerivation rec {
  name = "ucommon-5.0.5";

  src = fetchurl {
    url = mirror://gnu/commoncpp/ucommon-5.0.5.tar.gz;
    sha256 = "0rpq6qkhzcsls2rmnf1p1dnf9vyzmgw0cips3hl82mh0w5d70253";
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
