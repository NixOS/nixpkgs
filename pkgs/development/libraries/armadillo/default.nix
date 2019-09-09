{ stdenv, fetchurl, cmake, openblasCompat, superlu, hdf5 }:

stdenv.mkDerivation rec {
  pname = "armadillo";
  version = "9.600.6";

  src = fetchurl {
    url = "mirror://sourceforge/arma/armadillo-${version}.tar.xz";
    sha256 = "0wlk1yv9531vpvgja4cpy0sxykrn0p5w376kx86vl45b50yamx7g";
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
