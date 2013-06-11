{ stdenv, fetchurl, blas, liblapack, gfortran } :
stdenv.mkDerivation rec {
  version = "4.2.0";
  name = "suitesparse-${version}";
  src = fetchurl {
    url = "http://www.cise.ufl.edu/research/sparse/SuiteSparse/SuiteSparse-${version}.tar.gz" ;
    sha256 = "0i0ivsc5sr3jdz6nqq4wz5lwxc8rpnkqgddyhqqgfhwzgrcqh9v6";  			
  };
  buildInputs = [blas liblapack gfortran] ;
  patches = [./disable-metis.patch];

  preConfigure = ''
    export PREFIX=$out
    mkdir -p $out/lib
    mkdir -p $out/include
  '';

  makeFlags = ''PREFIX=\"$(out)\" INSTALL_LIB=$(out)/lib INSTALL_INCLUDE=$(out)/include'';

  NIX_CFLAGS = "-fPIC";

}
