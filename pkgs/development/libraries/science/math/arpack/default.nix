{ stdenv, fetchurl, gfortran, openblas }:

let version = "3.1.5";
in
stdenv.mkDerivation {
  name = "arpack-${version}";
  src = fetchurl {
    url = "http://forge.scilab.org/index.php/p/arpack-ng/downloads/get/arpack-ng_${version}.tar.gz";
    sha256 = "05fmg4m0yri47rzgsl2mnr1qbzrs7qyd557p3v9wwxxw0rwcwsd2";
  };

  buildInputs = [ gfortran ];
  propagatedBuildInputs = [ openblas ];

  preConfigure = ''
    substituteInPlace arpack.pc.in \
      --replace "@BLAS_LIBS@" "-L${openblas}/lib @BLAS_LIBS@"
  '';

  # Auto-detection fails because gfortran brings in BLAS by default
  configureFlags="--with-blas=-lopenblas --with-lapack=-lopenblas";

  meta = {
    homepage = "http://forge.scilab.org/index.php/p/arpack-ng/";
    description = "A collection of Fortran77 subroutines to solve large scale eigenvalue problems";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.ttuegel ];
  };
}
