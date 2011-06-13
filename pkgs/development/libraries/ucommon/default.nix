{ fetchurl, stdenv, gnutls, pkgconfig, zlib, libgcrypt }:

stdenv.mkDerivation rec {
  name = "ucommon-5.0.2";

  src = fetchurl {
    url = mirror://gnu/commoncpp/ucommon-5.0.2.tar.gz;
    sha256 = "05kc4h1b7wrm5fmgya9ashqmliv9qfv4wmvms86hiiry62l0r81g";
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
