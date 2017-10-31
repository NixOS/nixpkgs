{ stdenv, fetchurl, perl, gmp, libtool
}:

stdenv.mkDerivation rec {
  name = "ntl-${version}";
  version = "9.11.0";
  src = fetchurl {
    url = "http://www.shoup.net/ntl/ntl-${version}.tar.gz";
    sha256 = "1wcwxpcby1c50llncz131334qq26lzh3dz21rahymgvakrq0369p";
  };

  buildInputs = [ perl gmp libtool ];

  sourceRoot = "${name}/src";

  enableParallelBuilding = true;

  dontAddPrefix = true;

  configureFlags = [ "DEF_PREFIX=$(out)" "WIZARD=off" "SHARED=on" "NATIVE=off" "CXX=c++" ];

  # doCheck = true; # takes some time

  meta = {
    description = "A Library for doing Number Theory";
    longDescription = ''
      NTL is a high-performance, portable C++ library providing data
      structures and algorithms for manipulating signed, arbitrary
      length integers, and for vectors, matrices, and polynomials over
      the integers and over finite fields.
    '';
    homepage = http://www.shoup.net/ntl/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.all;
  };
}
