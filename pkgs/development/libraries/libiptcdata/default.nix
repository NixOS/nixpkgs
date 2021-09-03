{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "libiptcdata";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://sourceforge/libiptcdata/${pname}-${version}.tar.gz";
    sha256 = "03pfvkmmx762iydq0q207x2028d275pbdysfsgpmrr0ywy63pxkr";
  };

  meta = {
    description = "Library for reading and writing the IPTC metadata in images and other files";
    homepage = "http://libiptcdata.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
