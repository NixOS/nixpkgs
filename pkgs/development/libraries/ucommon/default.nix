{ fetchurl, stdenv, gnutls, pkgconfig, zlib, libgcrypt }:

stdenv.mkDerivation rec {
  name = "ucommon-6.1.11";

  src = fetchurl {
    url = "mirror://gnu/commoncpp/${name}.tar.gz";
    sha256 = "0hpwxiyd7c3qnzksk6vw94cdig1v8yy6khgcaa87a7hb3zbkv4zg";
  };

  buildInputs = [ pkgconfig gnutls zlib ];

  # Propagate libgcrypt because it appears in `ucommon.pc'.
  propagatedBuildInputs = [ libgcrypt ];

  doCheck = true;

  meta = {
    description = "C++ library to facilitate using C++ design patterns";
    homepage = http://www.gnu.org/software/commoncpp/;
    license = stdenv.lib.licenses.lgpl3Plus;

    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = stdenv.lib.platforms.all;
  };
}
