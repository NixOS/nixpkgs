{ stdenv, fetchurl, zlib, xz }:

stdenv.mkDerivation rec {
  name = "libpng-1.5.4";
  
  src = fetchurl {
    url = "mirror://sourceforge/libpng/${name}.tar.xz";
    sha256 = "1rw58zi3hxyinah2dz0jzq81c7ninbmfjf10xax2a8cpd5h45agz";
  };
  
  propagatedBuildInputs = [ zlib ];

  buildNativeInputs = [ xz ];

  passthru = { inherit zlib; };
  
  meta = {
    description = "The official reference implementation for the PNG file format";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = "free-non-copyleft"; # http://www.libpng.org/pub/png/src/libpng-LICENSE.txt
  };
}
