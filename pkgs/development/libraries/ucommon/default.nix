{ fetchurl, stdenv, gnutls, pkgconfig, zlib, libgcrypt }:

stdenv.mkDerivation rec {
  name = "ucommon-5.0.6";

  src = fetchurl {
    url = mirror://gnu/commoncpp/ucommon-5.0.6.tar.gz;
    sha256 = "102djhfzs5jp10r3ajm25p1phs9cxn2dx8vycf0i8vjhmd20yp5c";
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
