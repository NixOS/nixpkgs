{ stdenv, fetchurl, cmake, openblasCompat, superlu, hdf5 }:

stdenv.mkDerivation rec {
  version = "7.700.0";
  name = "armadillo-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/arma/armadillo-${version}.tar.xz";
    sha256 = "152x274hd3f59xgd27k9d3ikwb3w62v1v5hpw4lp1yzdyy8980pr";
  };

  buildInputs = [ cmake openblasCompat superlu hdf5 ];

  cmakeFlags = [ "-DDETECT_HDF5=ON" ];

  patches = [ ./use-unix-config-on-OS-X.patch ];
  
  meta = with stdenv.lib; {
    description = "C++ linear algebra library";
    homepage = http://arma.sourceforge.net;
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ juliendehos knedlsepp ];
  };
}
