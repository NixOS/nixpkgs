{ stdenv, fetchurl, cmake, openblasCompat, superlu, hdf5-cpp }:

stdenv.mkDerivation rec {
  version = "7.200.2";
  name = "armadillo-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/arma/armadillo-${version}.tar.xz";
    sha256 = "1yvx75caks477jqwx5gspi6946jialddk00wdvg6dnh5wdi2xasm";
  };

  buildInputs = [ cmake openblasCompat superlu hdf5-cpp ];

  cmakeFlags = [ "-DDETECT_HDF5=ON" ];

  patches = [ ./use-unix-config-on-OS-X.patch ];
  
  meta = with stdenv.lib; {
    description = "C++ linear algebra library";
    homepage = http://arma.sourceforge.net;
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.juliendehos ];
  };
}
