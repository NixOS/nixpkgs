{ fetchurl, stdenv, gnutls, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  name = "ucommon-4.2.0";

  src = fetchurl {
    url = mirror://gnu/commoncpp/ucommon-4.2.0.tar.gz;
    sha256 = "0w2695rf9hw407jhl1rxr2ika9syyhvd3il2g9jm1z1yk8zkl1jr";
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
