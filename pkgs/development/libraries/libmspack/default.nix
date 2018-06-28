{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "libmspack-0.6alpha";

  src = fetchurl {
    url = "https://www.cabextract.org.uk/libmspack/${name}.tar.gz";
    sha256 = "08gr2pcinas6bdqz3k0286g5cnksmcx813skmdwyca6bmj1fxnqy";
  };

  meta = {
    description = "A de/compression library for various Microsoft formats";
    homepage = https://www.cabextract.org.uk/libmspack;
    license = stdenv.lib.licenses.lgpl2;
    platforms = stdenv.lib.platforms.unix;
  };
}
