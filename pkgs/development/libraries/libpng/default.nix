{stdenv, fetchurl, zlib}:

assert zlib != null;

stdenv.mkDerivation {
  name = "libpng-1.2.32";
  
  src = fetchurl {
    url = mirror://sourceforge/libpng/libpng-1.2.32.tar.bz2;
    md5 = "df4a20c6f24a6f642ae11c9a5a4ffa7f";
  };
  
  propagatedBuildInputs = [zlib];
  
  inherit zlib;

  meta = {
    description = "The official reference implementation for the PNG file format";
    homepage = http://www.libpng.org/pub/png/libpng.html;
  };
}
