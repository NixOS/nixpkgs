{stdenv, fetchurl, gfortran

# Enable the Sun Grid Engine bindings
, enableSGE ? false

# Pass PATH/LD_LIBRARY_PATH to point to current mpirun by default
, enablePrefix ? false
}:

with stdenv.lib;

stdenv.mkDerivation {
  name = "openmpi-1.6.5";
  src = fetchurl {
    url = http://www.open-mpi.org/software/ompi/v1.6/downloads/openmpi-1.6.5.tar.bz2 ;
    sha256 = "11gws4d3z7934zna2r7m1f80iay2ha17kp42mkh39wjykfwbldzy";
  };
  buildInputs = [ gfortran ];
  configureFlags = []
    ++ optional enableSGE "--with-sge"
    ++ optional enablePrefix "--enable-mpirun-prefix-by-default"
    ;
  meta = {
    homePage = http://www.open-mpi.org/;
    description = "Open source MPI-2 implementation";
    longDescription = "The Open MPI Project is an open source MPI-2 implementation that is developed and maintained by a consortium of academic, research, and industry partners. Open MPI is therefore able to combine the expertise, technologies, and resources from all across the High Performance Computing community in order to build the best MPI library available. Open MPI offers advantages for system and software vendors, application developers and computer science researchers.";
    maintainers = [ stdenv.lib.maintainers.mornfall ];
  };
}

