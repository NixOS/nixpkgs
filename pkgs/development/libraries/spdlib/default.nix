{ stdenv, lib, cmake, fetchurl
, boost, hdf5-cpp, gdal, LAStools, xercesc, gsl, proj, cgal, LASzip, gmp
, mpfr
}:


stdenv.mkDerivation rec {
  version = "3.3.0";
  name = "spdlib-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/petebunting/spdlib/downloads/spdlib-${version}.tar.gz";
    sha256 = "1ixrjlaprqbzzgyg10xx175rwvscz9njs7jam293nyyvxv2m1lyy";
  };

  patches = [ ./cmake-fixes.patch ./remove-old-flags.patch ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost hdf5-cpp gdal LAStools xercesc gsl proj cgal LASzip gmp
                  mpfr ];

  enableParallelBuilding = true;

#  CMAKE_CXX_FLAGS = "-std=c++11 -Wno-deprecated-declarations -Wno-unused-result";

  cmakeFlags = ["-DLIBLAS_INCLUDE_DIR=${LAStools}/include/LASlib"
                "-DLIBLAS_LIB_PATH=${LAStools}/lib/LASlib"
               ];

  meta = {
    description = "SPDLib is a set of open source software tools for processing laser scanning data (i.e., LiDAR), including data captured from airborne and terrestrial platforms. ";
    homepage = http://www.spdlib.org/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.mpickering ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
