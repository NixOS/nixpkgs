{ lib, stdenv, fetchurl, cmake, blas, lapack, superlu, hdf5 }:

stdenv.mkDerivation rec {
  pname = "armadillo";
  version = "12.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/arma/armadillo-${version}.tar.xz";
    sha256 = "sha256-IwpcddqtUtxH4a3Oj1pQ+apOQ1Tg8bsY6oTvoucOIN8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ blas lapack superlu hdf5 ];

  cmakeFlags = [
    "-DLAPACK_LIBRARY=${lapack}/lib/liblapack${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DDETECT_HDF5=ON"
  ];

  patches = [ ./use-unix-config-on-OS-X.patch ];

  meta = with lib; {
    description = "C++ linear algebra library";
    homepage = "https://arma.sourceforge.net";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ juliendehos knedlsepp ];
  };
}
