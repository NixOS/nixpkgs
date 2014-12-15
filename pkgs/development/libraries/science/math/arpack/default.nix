{ stdenv, fetchurl, gfortran, openblas }:

let
  version = "3.2.0";
in
stdenv.mkDerivation {
  name = "arpack-${version}";
  src = fetchurl {
    url = "https://github.com/opencollab/arpack-ng/archive/${version}.tar.gz";
    sha256 = "1fwch6vipms1ispzg2djvbzv5wag36f1dmmr3xs3mbp6imfyhvff";
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
    # Looks like OpenBLAS is not that easy to build
    # there is a sgemm_itcopy undefined reference on 32-bit, for example
    platforms = ["x86_64-linux"];
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.ttuegel ];
  };
}
