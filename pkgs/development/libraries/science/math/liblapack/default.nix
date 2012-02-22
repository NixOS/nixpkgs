{ stdenv, fetchurl, gfortran, atlas, cmake, python }:

stdenv.mkDerivation {
  name = "liblapack-3.4.0";
  src = fetchurl {
    url = "http://www.netlib.org/lapack/lapack-3.4.0.tgz";
    sha256 = "1sf30v1ps5icg67dvw5sbx5yhypx13am470gqg2f7l04f3wrw4x7";
  };

  propagatedBuildInputs = [ atlas ];
  buildInputs = [ gfortran cmake ];
  buildNativeInputs = [ python ];

  cmakeFlags = [
    "-DUSE_OPTIMIZED_BLAS=ON"
    "-DBLAS_ATLAS_f77blas_LIBRARY=${atlas}/lib/libf77blas.a"
    "-DBLAS_ATLAS_atlas_LIBRARY=${atlas}/lib/libatlas.a"
    "-DCMAKE_Fortran_FLAGS=-fPIC"
  ];

  doCheck = true;

  checkPhase = "
    sed -i 's,^#!.*,#!${python}/bin/python,' lapack_testing.py
    ctest
  ";

  enableParallelBuilding = true;

  passthru = {
    blas = atlas;
  };

  meta = {
    description = "Linear Algebra PACKage";
    license = "revised-BSD";
    homepage = "http://www.netlib.org/lapack/";
  };
}
