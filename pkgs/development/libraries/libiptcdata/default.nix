{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "libiptcdata-1.0.4";

  src = fetchurl {
    url = "mirror://sourceforge/libiptcdata/${name}.tar.gz";
    sha256 = "03pfvkmmx762iydq0q207x2028d275pbdysfsgpmrr0ywy63pxkr";
  };

  meta = {
    description = "Library for reading and writing the IPTC metadata in images and other files";
    homepage = http://libiptcdata.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
