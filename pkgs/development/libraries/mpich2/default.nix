{ stdenv, fetchurl, python, perl, gfortran }:

stdenv.mkDerivation  rec {
  name = "mpich-${version}";
  version = "3.2";

  src = fetchurl {
    url = "http://www.mpich.org/static/downloads/3.2/mpich-3.2.tar.gz";
    sha256 = "0bvvk4n9g4rmrncrgs9jnkcfh142i65wli5qp1akn9kwab1q80z6";
  };

  configureFlags = "--enable-shared --enable-sharedlib";

  buildInputs = [ perl gfortran ];

  meta = {
    description = "Implementation of the Message Passing Interface (MPI) standard";

    longDescription = ''
      MPICH2 is a free high-performance and portable implementation of
      the Message Passing Interface (MPI) standard, both version 1 and
      version 2.
    '';
    homepage = http://www.mcs.anl.gov/mpi/mpich2/;
    license = "free, see http://www.mcs.anl.gov/research/projects/mpich2/downloads/index.php?s=license";

    maintainers = [ ];
    platforms = stdenv.lib.platforms.unix;
  };
}
