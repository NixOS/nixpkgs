{ stdenv, fetchurl, gfortran, openblas }:

with stdenv.lib;

let
  version = "3.2.0";
in
stdenv.mkDerivation {
  name = "arpack-${version}";
  src = fetchurl {
    url = "https://github.com/opencollab/arpack-ng/archive/${version}.tar.gz";
    sha256 = "1fwch6vipms1ispzg2djvbzv5wag36f1dmmr3xs3mbp6imfyhvff";
  };

  buildInputs = [ gfortran openblas ];

  # Auto-detection fails because gfortran brings in BLAS by default
  configureFlags = [
    "--with-blas=-lopenblas"
    "--with-lapack=-lopenblas"
  ];

  FFLAGS = optional openblas.blas64 "-fdefault-integer-8";

  meta = {
    homepage = "http://github.com/opencollab/arpack-ng";
    description = ''
      A collection of Fortran77 subroutines to solve large scale eigenvalue
      problems.
    '';
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.ttuegel ];
  };
}
