{stdenv, fetchurl, zlib}:

assert zlib != null;

stdenv.mkDerivation {
  name = "libpng-1.2.29";
  src = fetchurl {
    url = mirror://sourceforge/libpng/libpng-1.2.29.tar.bz2;
    md5 = "f588cb4ee39e3a333604096f937ea157";
  };
  propagatedBuildInputs = [zlib];
  inherit zlib;

  meta = {
    description = "The official reference implementation for the PNG file format";
    homepage = http://www.libpng.org/pub/png/libpng.html;
  };
}
