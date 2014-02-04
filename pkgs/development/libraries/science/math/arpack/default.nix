{ stdenv, fetchurl, gfortran, openblas }:

let version = "3.1.4";
in
stdenv.mkDerivation {
  name = "arpack-${version}";
  src = fetchurl {
    url = "http://forge.scilab.org/index.php/p/arpack-ng/downloads/get/arpack-ng_${version}.tar.gz";
    sha256 = "0m4cqy3d7fpzx1nac3brhr298qj7vx3fchjdz5b7n0pp616cmcm1";
  };

  buildInputs = [ gfortran ];
  propagatedBuildInputs = [ openblas ];

  # Auto-detection fails because gfortran brings in BLAS by default
  configureFlags="--with-blas=-lopenblas --with-lapack=-lopenblas";

  meta = {
    homepage = "http://forge.scilab.org/index.php/p/arpack-ng/";
    description = "A collection of Fortran77 subroutines to solve large scale eigenvalue problems";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.bsd3;
  };
}
