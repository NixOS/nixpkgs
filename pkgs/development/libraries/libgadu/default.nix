{stdenv, fetchurl, zlib}:

stdenv.mkDerivation {

  name = "libgadu-1.11.0";

  src = fetchurl {
    url = http://toxygen.net/libgadu/files/libgadu-1.11.0.tar.gz;
    sha256 = "045a0bd395k3ramdvlzyfx3878p42fv4r04rgasmdsm2n33wgm38";
  };

  propagatedBuildInputs = [ zlib ];

  meta = {
    description = "A library to deal with gadu-gadu protocol (most popular polish IM protocol)";
    homepage = http://toxygen.net/libgadu/;
    platforms = stdenv.lib.platforms.linux;
    license = "LGPLv2.1";
  };

}
