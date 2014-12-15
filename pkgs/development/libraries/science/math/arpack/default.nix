{ stdenv, fetchurl, gfortran, atlasWithLapack }:

let
  version = "3.2.0";
in
stdenv.mkDerivation {
  name = "arpack-${version}";
  src = fetchurl {
    url = "https://github.com/opencollab/arpack-ng/archive/${version}.tar.gz";
    sha256 = "1fwch6vipms1ispzg2djvbzv5wag36f1dmmr3xs3mbp6imfyhvff";
  };

  buildInputs = [ gfortran atlasWithLapack ];

  # Auto-detection fails because gfortran brings in BLAS by default
  configureFlags="--with-blas=-latlas --with-lapack=-latlas";

  meta = {
    homepage = "http://forge.scilab.org/index.php/p/arpack-ng/";
    description = ''
      A collection of Fortran77 subroutines to solve large scale eigenvalue
      problems.
    '';
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.ttuegel ];
  };
}
