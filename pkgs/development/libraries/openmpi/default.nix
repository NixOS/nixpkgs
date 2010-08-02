{stdenv, fetchurl, gfortran}:

stdenv.mkDerivation {
  name = "openmpi-1.4.2";
  src = fetchurl {
    url = http://www.open-mpi.org/software/ompi/v1.4/downloads/openmpi-1.4.2.tar.bz2 ;
    sha1 = "3e85092433d0e399cc7a51c018f9d13562f78b80";
  };
  buildInputs = [ gfortran ];
}

