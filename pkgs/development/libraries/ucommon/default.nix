{ fetchurl, stdenv, gnutls, pkgconfig, zlib, libgcrypt }:

stdenv.mkDerivation rec {
  name = "ucommon-5.0.1";

  src = fetchurl {
    url = mirror://gnu/commoncpp/ucommon-5.0.1.tar.gz;
    sha256 = "14a1da3gpwf6m5w7fisjfmv7j67is0fwrwdkkd7fjvy0amc33dhd";
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
