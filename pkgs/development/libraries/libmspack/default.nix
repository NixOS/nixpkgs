{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libmspack-0.5alpha";
  src = fetchurl {
    url = "http://www.cabextract.org.uk/libmspack/libmspack-0.5alpha.tar.gz";
    sha256 = "04413hynb7zizxnkgy9riik3612dwirkpr6fcjrnfl2za9sz4rw9";
  };

  meta = {
    description = "A de/compression library for various Microsoft formats";
    homepage = http://www.cabextract.org.uk/libmspack;
    license = stdenv.lib.licenses.lgpl2;
    platforms = stdenv.lib.platforms.unix;
  };
}
