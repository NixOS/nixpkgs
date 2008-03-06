{stdenv, fetchurl, zlib}:

assert zlib != null;

stdenv.mkDerivation {
  name = "libpng-1.2.25";
  src = fetchurl {
    url = mirror://sourceforge/libpng/libpng-1.2.25.tar.bz2;
    sha256 = "1q3w2lfr7vkzvfxdgf54vj5s29xw8fg3hzb1lnfy9m9j1kdfm4if";
  };
  propagatedBuildInputs = [zlib];
  inherit zlib;

  meta = {
    description = "The official reference implementation for the PNG file format";
    homepage = http://www.libpng.org/pub/png/libpng.html;
  };
}
