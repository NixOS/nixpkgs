{ stdenv
, fetchurl
, gfortran
, liblapack
}:
stdenv.mkDerivation {
  name = "qrupdate-1.1.2";
  src = fetchurl {
    url = mirror://sourceforge/qrupdate/qrupdate-1.1.2.tar.gz ;
    sha256 = "024f601685phcm1pg8lhif3lpy5j9j0k6n0r46743g4fvh8wg8g2";  			
  };
  
  configurePhase = ''
    export PREFIX=$out
    sed -i -e 's,^BLAS=.*,BLAS=-L${liblapack}/lib -L${liblapack.blas} -lcblas -lf77blas -latlas,' \
      -e 's,^LAPACK=.*,LAPACK=-L${liblapack}/lib -llapack -lcblas -lf77blas -latlas,' \
      Makeconf
  '';

  doCheck = true;

  checkTarget = "test";

  buildTarget = "lib";

  installTarget = "install-staticlib";
  
  buildInputs = [ gfortran liblapack ];
}
