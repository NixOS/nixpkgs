{ stdenv
, fetchurl
, gfortran
, blas
, liblapack
}:
stdenv.mkDerivation {
  name = "qrupdate-1.1.1";
  src = fetchurl {
    url = mirror://sourceforge/qrupdate/1.1/qrupdate-1.1.1.tar.gz ;
    sha256 = "0ak68qd15zccr2d2qahxcxsrcdgxy7drg362jj9swv7rb39h00cz";  			
  };
  
  preConfigure = ''
    export PREFIX=$out
  '';
  
  buildInputs = [gfortran blas liblapack] ;
}
