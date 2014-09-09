{ stdenv, fetchurl, gfortran, atlas, cmake, python, shared ? false }:
let
  atlasMaybeShared = atlas.override { inherit shared; };
  usedLibExtension = if shared then ".so" else ".a";
in
stdenv.mkDerivation rec {
  version = "3.5.0";
  name = "liblapack-${version}";
  src = fetchurl {
    url = "http://www.netlib.org/lapack/lapack-${version}.tgz";
    sha256 = "0lk3f97i9imqascnlf6wr5mjpyxqcdj73pgj97dj2mgvyg9z1n4s";
  };

  propagatedBuildInputs = [ atlasMaybeShared ];
  buildInputs = [ gfortran cmake ];
  nativeBuildInputs = [ python ];

  cmakeFlags = [
    "-DUSE_OPTIMIZED_BLAS=ON"
    "-DBLAS_ATLAS_f77blas_LIBRARY=${atlasMaybeShared}/lib/libf77blas${usedLibExtension}"
    "-DBLAS_ATLAS_atlas_LIBRARY=${atlasMaybeShared}/lib/libatlas${usedLibExtension}"
    "-DCMAKE_Fortran_FLAGS=-fPIC"
  ]
  ++ (stdenv.lib.optional shared "-DBUILD_SHARED_LIBS=ON")
  ;

  doCheck = ! shared;

  checkPhase = "
    sed -i 's,^#!.*,#!${python}/bin/python,' lapack_testing.py
    ctest
  ";

  enableParallelBuilding = true;

  passthru = {
    blas = atlas;
  };

  meta = {
    inherit version;
    description = "Linear Algebra PACKage";
    homepage = "http://www.netlib.org/lapack/";
    license = "revised-BSD";

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
