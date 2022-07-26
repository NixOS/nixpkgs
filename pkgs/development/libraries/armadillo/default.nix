{ lib, stdenv, fetchurl, cmake, blas, lapack, superlu, hdf5 }:

stdenv.mkDerivation rec {
  pname = "armadillo";
  version = "11.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/arma/armadillo-${version}.tar.xz";
    sha256 = "sha256-1AHZmkImwoxb+9nUMB8LM/4sgAyoZavgDNnFk+OTpic=";
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
    homepage = "http://arma.sourceforge.net";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ juliendehos knedlsepp ];
  };
}
