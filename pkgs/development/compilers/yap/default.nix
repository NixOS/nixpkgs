{ stdenv, fetchurl, readline, gmp, zlib }:

stdenv.mkDerivation rec {
  version = "6.3.3";
  name = "yap-${version}";

  src = fetchurl {
    url = "https://www.dcc.fc.up.pt/~vsc/Yap/${name}.tar.gz";
    sha256 = "0y7sjwimadqsvgx9daz28c9mxcx9n1znxklih9xg16k6n54v9qxf";
  };

  buildInputs = [ readline gmp zlib ];

  configureFlags = [ "--enable-tabling=yes" ];

  NIX_CFLAGS_COMPILE = [ "-fpermissive" ];

  meta = {
    homepage = http://www.dcc.fc.up.pt/~vsc/Yap/;
    description = "A ISO-compatible high-performance Prolog compiler";
    license = stdenv.lib.licenses.artistic2;

    maintainers = [ stdenv.lib.maintainers.peti ];
    platforms = stdenv.lib.platforms.linux;
    broken = !stdenv.is64bit;   # the linux 32 bit build fails.
  };
}
