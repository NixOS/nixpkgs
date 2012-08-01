{ stdenv, fetchurl, blas, liblapack, gfortran } :
stdenv.mkDerivation rec {
  version = "4.0.0";
  name = "suitesparse-${version}";
  src = fetchurl {
    url = "http://www.cise.ufl.edu/research/sparse/SuiteSparse/SuiteSparse-${version}.tar.gz" ;
    sha256 = "1nvbdw10wa6654k8sa2vhr607q6fflcywyji5xd767cqpwag4v5j";  			
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
