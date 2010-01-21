{stdenv, fetchurl, zlib}:

assert zlib != null;

stdenv.mkDerivation rec {
  name = "libpng-1.4.0";
  
  src = fetchurl {
    url = "mirror://sourceforge/libpng/${name}.tar.gz";
    md5 = "dfa01122db3be9808a8c9ace7d0580fd";
  };
  
  propagatedBuildInputs = [zlib];
  
  inherit zlib;

  meta = {
    description = "The official reference implementation for the PNG file format";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = "free-non-copyleft"; # http://www.libpng.org/pub/png/src/libpng-LICENSE.txt
  };
}
