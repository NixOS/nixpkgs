{
  stdenv,
  fetchurl,
  gfortran,
  cmake,
  python2,
  shared ? false
}:
let
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

  buildInputs = [ gfortran cmake ];
  nativeBuildInputs = [ python2 ];

  cmakeFlags = [
    "-DUSE_OPTIMIZED_BLAS=ON"
    "-DCMAKE_Fortran_FLAGS=-fPIC"
  ]
  ++ (optional shared "-DBUILD_SHARED_LIBS=ON");

  doCheck = ! shared;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    inherit version;
    description = "Linear Algebra PACKage";
    homepage = http://www.netlib.org/lapack/;
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
