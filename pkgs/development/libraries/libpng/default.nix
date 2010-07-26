{ stdenv, fetchurl, zlib }:

assert zlib != null;

stdenv.mkDerivation rec {
  name = "libpng-1.2.44";
  
  src = fetchurl {
    url = "mirror://sourceforge/libpng/${name}.tar.gz";
    md5 = "89b62f8daaeeab1342e307d6d1411ff1";
  };
  
  propagatedBuildInputs = [ zlib ];

  passthru = { inherit zlib; };
  
  meta = {
    description = "The official reference implementation for the PNG file format";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = "free-non-copyleft"; # http://www.libpng.org/pub/png/src/libpng-LICENSE.txt
  };
}
