{stdenv, fetchurl, gfortran, perl, rdma-core

# Enable the Sun Grid Engine bindings
, enableSGE ? false

# Pass PATH/LD_LIBRARY_PATH to point to current mpirun by default
, enablePrefix ? false
}:

with stdenv.lib;

let
  majorVersion = "3.0";

in stdenv.mkDerivation rec {
  name = "openmpi-${majorVersion}.0";

  src = fetchurl {
    url = "http://www.open-mpi.org/software/ompi/v${majorVersion}/downloads/${name}.tar.bz2";
    sha256 = "1mw2d94k6mp4scg1wnkj50vdh734fy5m2ygyrj65s4mh3prbz6gn";
  };

  buildInputs = [ gfortran ]
    ++ optional (stdenv.isLinux || stdenv.isFreeBSD) rdma-core;

  nativeBuildInputs = [ perl ];

  configureFlags = []
    ++ optional enableSGE "--with-sge"
    ++ optional enablePrefix "--enable-mpirun-prefix-by-default"
    ;

  enableParallelBuilding = true;

  preBuild = ''
    patchShebangs ompi/mpi/fortran/base/gen-mpi-sizeof.pl
  '';

  postInstall = ''
		rm -f $out/lib/*.la
   '';

  meta = {
    homepage = http://www.open-mpi.org/;
    description = "Open source MPI-2 implementation";
    longDescription = "The Open MPI Project is an open source Message Passing Interface implementation that is developed and maintained by a consortium of academic, research, and industry partners. Open MPI is therefore able to combine the expertise, technologies, and resources from all across the High Performance Computing community in order to build the best MPI library available. Open MPI offers advantages for system and software vendors, application developers and computer science researchers.";
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
