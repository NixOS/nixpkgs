{ stdenv, fetchurl, blas, liblapack, gfortran } :
stdenv.mkDerivation rec {
  version = "4.2.1";
  name = "suitesparse-${version}";
  src = fetchurl {
    url = "http://www.cise.ufl.edu/research/sparse/SuiteSparse/SuiteSparse-${version}.tar.gz" ;
    sha256 = "1ga69637x7kdkiy3w3lq9dvva7220bdangv2lch2wx1hpi83h0p8";  			
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
