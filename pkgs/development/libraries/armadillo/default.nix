{ stdenv, fetchurl, cmake, openblasCompat, superlu, hdf5 }:

stdenv.mkDerivation rec {
  pname = "armadillo";
  version = "9.850.1";

  src = fetchurl {
    url = "mirror://sourceforge/arma/armadillo-${version}.tar.xz";
    sha256 = "07y0s87srj2wxbywmnxam9bif0x625n6b8np19832mvsb6wqkhyl";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openblasCompat superlu hdf5 ];

  cmakeFlags = [
    "-DLAPACK_LIBRARY=${openblasCompat}/lib/libopenblas${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DDETECT_HDF5=ON"
  ];

  patches = [ ./use-unix-config-on-OS-X.patch ];

  meta = with stdenv.lib; {
    description = "C++ linear algebra library";
    homepage = http://arma.sourceforge.net;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ juliendehos knedlsepp ];
  };
}
