{ stdenv, lib, copyPathsToStore, fetchurl, autoconf, automake, gettext, libtool
, gfortran, openblas }:

with stdenv.lib;

let
  version = "3.3.0";
in
stdenv.mkDerivation {
  name = "arpack-${version}";

  src = fetchurl {
    url = "https://github.com/opencollab/arpack-ng/archive/${version}.tar.gz";
    sha256 = "1cz53wqzcf6czmcpfb3vb61xi0rn5bwhinczl65hpmbrglg82ndd";
  };

  nativeBuildInputs = [ autoconf automake gettext libtool ];
  buildInputs = [ gfortran openblas ];

  BLAS_LIBS = "-L${openblas}/lib -lopenblas";

  FFLAGS = optional openblas.blas64 "-fdefault-integer-8";

  preConfigure = ''
    ./bootstrap
  '';

  meta = {
    homepage = "http://github.com/opencollab/arpack-ng";
    description = ''
      A collection of Fortran77 subroutines to solve large scale eigenvalue
      problems.
    '';
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.ttuegel ];
    platforms = stdenv.lib.platforms.unix;
  };
}
