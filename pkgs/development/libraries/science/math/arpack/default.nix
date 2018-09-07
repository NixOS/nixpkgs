{ stdenv, fetchurl, autoconf, automake, gettext, libtool
, gfortran, openblas }:

with stdenv.lib;

let
  version = "3.5.0";
in
stdenv.mkDerivation {
  name = "arpack-${version}";

  src = fetchurl {
    url = "https://github.com/opencollab/arpack-ng/archive/${version}.tar.gz";
    sha256 = "0f8jx3fifmj9qdp289zr7r651y1q48k1jya859rqxq62mvis7xsh";
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
