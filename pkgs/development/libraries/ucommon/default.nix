{ fetchurl, stdenv, gnutls, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  name = "ucommon-4.1.7";

  src = fetchurl {
    url = mirror://gnu/commoncpp/ucommon-4.1.7.tar.gz;
    sha256 = "1qbfhi3gfzjs44ilaipv0ynjvilxk06897g0zk974g0fgk98dd7i";
  };

  buildInputs = [ pkgconfig gnutls zlib ];

  doCheck = true;

  meta = {
    description = "GNU uCommon C++, C++ library to facilitate using C++ design patterns";
    homepage = http://www.gnu.org/software/commoncpp/;
    license = "LGPLv3+";

    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.all;
  };
}
