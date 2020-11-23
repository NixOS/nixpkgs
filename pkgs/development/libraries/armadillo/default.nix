{ stdenv, fetchurl, cmake, blas, lapack, superlu, hdf5 }:

stdenv.mkDerivation rec {
  pname = "armadillo";
  version = "10.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/arma/armadillo-${version}.tar.xz";
    sha256 = "0pb3ypdaiiw0895x1zzzjvkrfp39bsl3s4f6zb5bzv4wbjv7kvwn";
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
