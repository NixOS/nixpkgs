{ stdenv, fetchurl, cmake, blas, lapack, superlu, hdf5 }:

stdenv.mkDerivation rec {
  pname = "armadillo";
  version = "9.870.2";

  src = fetchurl {
    url = "mirror://sourceforge/arma/armadillo-${version}.tar.xz";
    sha256 = "0mpp1iq4ws9yhcv0bnn0czzyim7whcan34c7a052sh8w9kp5y6sl";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ blas lapack superlu hdf5 ];

  cmakeFlags = [
    "-DLAPACK_LIBRARY=${lapack}/lib/liblapack${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DDETECT_HDF5=ON"
  ];

  patches = [ ./use-unix-config-on-OS-X.patch ];

  meta = with stdenv.lib; {
    description = "C++ linear algebra library";
    homepage = "http://arma.sourceforge.net";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ juliendehos knedlsepp ];
  };
}
