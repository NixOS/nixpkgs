{stdenv, fetchurl, zlib}:

assert zlib != null;

stdenv.mkDerivation rec {
  name = "libpng-1.2.40";
  
  src = fetchurl {
    url = "mirror://sourceforge/libpng/${name}.tar.gz";
    md5 = "a2f6808735bf404967f81519a967fb2a";
  };
  
  propagatedBuildInputs = [zlib];
  
  inherit zlib;

  meta = {
    description = "The official reference implementation for the PNG file format";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = "free-non-copyleft"; # http://www.libpng.org/pub/png/src/libpng-LICENSE.txt
  };
}
