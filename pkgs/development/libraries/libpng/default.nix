{stdenv, fetchurl, zlib}:

assert zlib != null;

stdenv.mkDerivation {
  name = "libpng-1.2.16";
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/libpng/libpng-1.2.16.tar.bz2;
    md5 = "7a1ca4f49bcffdec60d50f48460642bd";
  };
  propagatedBuildInputs = [zlib];
  inherit zlib;
}
