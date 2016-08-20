{
  stdenv,
  fetchurl,
  gfortran,
  cmake,
  python2,
  atlas ? null,
  shared ? false
}:
let
  atlasMaybeShared = if atlas != null then atlas.override { inherit shared; }
                     else null;
  usedLibExtension = if shared then ".so" else ".a";
  inherit (stdenv.lib) optional optionals;
  version = "3.8.0";
in

stdenv.mkDerivation rec {
  name = "liblapack-${version}";
  src = fetchurl {
    url = "http://www.netlib.org/lapack/lapack-${version}.tar.gz";
    sha256 = "1xmwi2mqmipvg950gb0rhgprcps8gy8sjm8ic9rgy2qjlv22rcny";
  };

  propagatedBuildInputs = [ atlasMaybeShared ];
  buildInputs = [ gfortran cmake ];
  nativeBuildInputs = [ python2 ];

  cmakeFlags = {
    BUILD_SHARED_LIBS = shared;
    CMAKE_Fortran_FLAGS = "-fPIC";
    USE_OPTIMIZED_BLAS = true;
  } // (optionalAttrs (atlas != null) {
    BLAS_ATLAS_atlas_LIBRARY = "${atlasMaybeShared}/lib/libatlas${usedLibExtension}";
    BLAS_ATLAS_f77blas_LIBRARY = "${atlasMaybeShared}/lib/libf77blas${usedLibExtension}";
  }) // (optionalAttrs stdenv.isDarwin {
    # If we're on darwin, CMake will automatically detect impure paths. This switch
    # prevents that.
    CMAKE_OSX_SYSROOT = "";
  });

  doCheck = ! shared;

  checkPhase = "
    ctest
  ";

  enableParallelBuilding = true;

  passthru = {
    blas = atlas;
  };

  meta = with stdenv.lib; {
    inherit version;
    description = "Linear Algebra PACKage";
    homepage = http://www.netlib.org/lapack/;
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
