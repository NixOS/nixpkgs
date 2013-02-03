{stdenv, fetchurl, gfortran}:

stdenv.mkDerivation {
  name = "openmpi-1.6.4";
  src = fetchurl {
    url = http://www.open-mpi.org/software/ompi/v1.6/downloads/openmpi-1.6.4.tar.bz2 ;
    sha1 = "38095d3453519177272f488d5058a98f7ebdbf10";
  };
  buildInputs = [ gfortran ];
  meta = {
    homePage = http://www.open-mpi.org/;
    description = "Open source MPI-2 implementation";
    longDescription = "The Open MPI Project is an open source MPI-2 implementation that is developed and maintained by a consortium of academic, research, and industry partners. Open MPI is therefore able to combine the expertise, technologies, and resources from all across the High Performance Computing community in order to build the best MPI library available. Open MPI offers advantages for system and software vendors, application developers and computer science researchers.";
  };
}

