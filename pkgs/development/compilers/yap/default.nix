{ stdenv, fetchurl, readline, gmp, zlib }:

stdenv.mkDerivation rec {
  version = "6.3.3";
  name = "yap-${version}";

  src = fetchurl {
    url = "http://www.dcc.fc.up.pt/~vsc/Yap/${name}.tar.gz";
    sha256 = "0y7sjwimadqsvgx9daz28c9mxcx9n1znxklih9xg16k6n54v9qxf";
  };

  buildInputs = [ readline gmp zlib ];

  configureFlags = "--enable-tabling=yes";

  meta = {
    homepage = "http://www.dcc.fc.up.pt/~vsc/Yap/";
    description = "Yap Prolog System is a ISO-compatible high-performance Prolog compiler";
    license = stdenv.lib.licenses.artistic2;

    maintainers = [ stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.linux;
  };
}
