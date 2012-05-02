{ stdenv, fetchurl, blas, liblapack, gfortran } :
stdenv.mkDerivation {
  name = "suitesparse";
  src = fetchurl {
    url = http://www.cise.ufl.edu/research/sparse/SuiteSparse/SuiteSparse-3.5.0.tar.gz ;
    sha256 = "0npn7c1j5qag5m2r0cmh3bwc42c1jk8k2yg2cfyxlcrp0h7wn4rc";  			
  };
  buildInputs = [blas liblapack gfortran] ;
  patches = [./disable-metis.patch];

  preConfigure = ''
    export PREFIX=$out
    mkdir -p $out/lib
    mkdir -p $out/include
  '';

  NIX_CFLAGS = "-fPIC";

}
