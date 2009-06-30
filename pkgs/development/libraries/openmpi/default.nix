{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "openmpi-1.3.2";
  src = fetchurl {
    url = http://www.open-mpi.org/software/ompi/v1.3/downloads/openmpi-1.3.2.tar.gz ;
    sha256 = "1n7c0y4nidm0ha23ic7f872qh3296rh2177r1wqqs83k2ma7xxxb";
  };
}

