{ stdenv, fetchurl, autoconf, automake, gettext, libtool
, gfortran, openblas }:

with stdenv.lib;

let
  version = "3.6.3";
in
stdenv.mkDerivation {
  name = "arpack-${version}";

  src = fetchurl {
    url = "https://github.com/opencollab/arpack-ng/archive/${version}.tar.gz";
    sha256 = "0lzlcsrjsi36pv5bnipwjnyg2fx3nrv31bw2klwrg11gb8g5bwv4";
  };

  nativeBuildInputs = [ autoconf automake gettext libtool ];
  buildInputs = [ gfortran openblas ];

  doCheck = true;

  BLAS_LIBS = "-L${openblas}/lib -lopenblas";

  INTERFACE64 = optional openblas.blas64 "1";

  preConfigure = ''
    ./bootstrap
  '';

  meta = {
    homepage = https://github.com/opencollab/arpack-ng;
    description = ''
      A collection of Fortran77 subroutines to solve large scale eigenvalue
      problems.
    '';
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.ttuegel ];
    platforms = stdenv.lib.platforms.unix;
  };
}
