{ stdenv, fetchurl, cmake, openblasCompat, superlu, hdf5 }:

stdenv.mkDerivation rec {
  version = "9.300.2";
  name = "armadillo-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/arma/armadillo-${version}.tar.xz";
    sha256 = "1d2nsbspj9vzgzb6w2vgjv2wzidjzc8sr8wkz2zl7wxpgspl299n";
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
