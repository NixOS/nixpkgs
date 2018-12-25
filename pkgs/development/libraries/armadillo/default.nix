{ stdenv, fetchurl, cmake, openblasCompat, superlu, hdf5 }:

stdenv.mkDerivation rec {
  version = "9.200.6";
  name = "armadillo-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/arma/armadillo-${version}.tar.xz";
    sha256 = "1gm8dysb29f3p96bzjgdb5r70dc6y5jq1avg18sdixz0hgnxqq14";
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
