{stdenv, fetchurl}:

stdenv.mkDerivation {

  name = "libgadu-1.9.0";

  src = fetchurl {
    url = http://toxygen.net/libgadu/files/libgadu-1.9.0.tar.gz;
    sha256 = "1ygmda23hf7cysns9kglsiljzb4x8339n878k70yacgzm07dryhj";
  };

  meta = {
    description = "A library to deal with gadu-gadu protocol (most popular polish IM protocol)";
    homepage = http://toxygen.net/libgadu/;
    platforms = stdenv.lib.platforms.linux;
    license = "LGPLv2.1";
  };

}
