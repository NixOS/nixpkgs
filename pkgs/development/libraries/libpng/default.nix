{stdenv, fetchurl, zlib}:

assert zlib != null;

stdenv.mkDerivation {
  name = "libpng-1.2.5";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/png-mng/libpng-1.2.5.tar.bz2;
    md5 = "3fc28af730f12ace49b14568de4ad934";
  };
  zlib = zlib;
}
