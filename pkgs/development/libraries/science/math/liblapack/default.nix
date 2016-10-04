{
  stdenv,
  fetchurl,
  gfortran,
  cmake,
  python,
  atlas ? null,
  shared ? false
}:
let
  atlasMaybeShared = if atlas != null then atlas.override { inherit shared; }
                     else null;
  usedLibExtension = if shared then ".so" else ".a";
  inherit (stdenv.lib) optional optionals concatStringsSep;
  inherit (builtins) hasAttr attrNames;
  version = "3.4.1";
in

stdenv.mkDerivation rec {
  name = "liblapack-${version}";
  src = fetchurl {
    url = "http://www.netlib.org/lapack/lapack-${version}.tgz";
    sha256 = "93b910f94f6091a2e71b59809c4db4a14655db527cfc5821ade2e8c8ab75380f";
  };

  propagatedBuildInputs = [ atlasMaybeShared ];
  buildInputs = [ gfortran cmake ];
  nativeBuildInputs = [ python ];

  cmakeFlags = [
    "-DUSE_OPTIMIZED_BLAS=ON"
    "-DCMAKE_Fortran_FLAGS=-fPIC"
  ]
  ++ (optionals (atlas != null) [
    "-DBLAS_ATLAS_f77blas_LIBRARY=${atlasMaybeShared}/lib/libf77blas${usedLibExtension}"
    "-DBLAS_ATLAS_atlas_LIBRARY=${atlasMaybeShared}/lib/libatlas${usedLibExtension}"
  ])
  ++ (optional shared "-DBUILD_SHARED_LIBS=ON")
  # If we're on darwin, CMake will automatically detect impure paths. This switch
  # prevents that.
  ++ (optional stdenv.isDarwin "-DCMAKE_OSX_SYSROOT:PATH=''")
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

  meta = with stdenv.lib; {
    inherit version;
    description = "Linear Algebra PACKage";
    homepage = "http://www.netlib.org/lapack/";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
