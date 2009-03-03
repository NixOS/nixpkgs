{stdenv, fetchurl, python}:

stdenv.mkDerivation rec {
  name = "mpich2-1.0.6p1";
  
  src = fetchurl {
    url = "http://www.mcs.anl.gov/research/projects/mpich2/downloads/tarballs/${name}.tar.gz";
    sha256 = "1k0za8951j5fn89ww6bsy9b4yi989zz7bnd8a6acfr8r0yb8z01q";
  };

  buildInputs = [ python ];

  meta = {
    longDescription = ''
      MPICH2 is a free high-performance and portable implementation of
      the Message Passing Interface (MPI) standard, both version 1 and
      version 2.
    '';
    homepage = http://www.mcs.anl.gov/mpi/mpich2/;
    license = "free, see http://www.mcs.anl.gov/research/projects/mpich2/downloads/index.php?s=license";
  };
}
