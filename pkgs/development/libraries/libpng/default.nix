{stdenv, fetchurl, zlib}:

assert zlib != null;

stdenv.mkDerivation rec {
  name = "libpng-1.2.35";
  
  src = fetchurl {
    url = mirror://sourceforge/libpng/libpng-1.2.35.tar.bz2;
    md5 = "b8b8d09adf6bee2c5902c8e54c4f2e68";
  };
  
  propagatedBuildInputs = [zlib];
  
  inherit zlib;

  meta = {
    description = "The official reference implementation for the PNG file format";
    homepage = http://www.libpng.org/pub/png/libpng.html;
  };
}
