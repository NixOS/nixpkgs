{ stdenv, fetchurl, gfortran, blas, liblapack, metis, openmpi, scalapack, scotch }:

stdenv.mkDerivation rec {
  name = "mumps";
  version = "5.1.2-p2";

  src = fetchurl {
    url = "https://bitbucket.org/petsc/pkg-mumps/get/v${version}.tar.gz";
    sha256 = "0211njml8pxhj69pj5p2vjwvwz94wxzd8knd9yq69z8w7qrs5b4a";
  };

  patchPhase = ''
    ln -s Make.inc/Makefile.debian.PAR Makefile.inc
    substituteInPlace Makefile.inc \
      --replace "LSCOTCHDIR = /usr/lib" "LSCOTCHDIR = ${scotch}/lib" \
      --replace "ISCOTCH   = -I/usr/include/scotch" "ISCOTCH   = -I${scotch}/include" \
      --replace "LMETISDIR = /usr/lib" "LMETISDIR = ${metis}/lib" \
      --replace "IMETIS    = -I/usr/include/metis" "IMETIS    = -I${metis}/include" \
      --replace "INCPAR = -I/usr/lib/openmpi/include" "INCPAR = -I${openmpi}/include" \
      --replace 'LIBPAR = $(SCALAP) $(LAPACK)  -lmpi -lmpi_f77' 'LIBPAR = $(SCALAP) $(LAPACK) -lmpi -lmpi_mpifh' \
      --replace "SCALAP  = -lscalapack-openmpi -lblacs-openmpi  -lblacsF77init-openmpi -lblacsCinit-openmpi" "SCALAP  = -lscalapack"
  '';

  buildFlags = [ "all" ];

  installPhase = ''
    mkdir -p $out/lib
    cp -R include $out
    cp lib/*.a $out/lib
  '';

  buildInputs = [ gfortran blas liblapack metis openmpi scalapack scotch ];

  meta = {
    description = "A parallel sparse direct solver";
    homepage = http://mumps-solver.org/;
    license = stdenv.lib.licenses.cecill-c;
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ jamtrott ];
  };
}
