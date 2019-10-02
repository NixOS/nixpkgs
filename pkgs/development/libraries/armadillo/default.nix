{ stdenv, fetchurl, cmake, openblasCompat, superlu, hdf5 }:

stdenv.mkDerivation rec {
  pname = "armadillo";
  version = "9.700.2";

  src = fetchurl {
    url = "mirror://sourceforge/arma/armadillo-${version}.tar.xz";
    sha256 = "1g88mizzkza91v51fz174gg0700f6y6snshplffpqw2gjx42ngwj";
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
