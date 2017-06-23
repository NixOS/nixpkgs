{stdenv, fetchurl, gfortran, perl, libibverbs

# Enable the Sun Grid Engine bindings
, enableSGE ? false

# Pass PATH/LD_LIBRARY_PATH to point to current mpirun by default
, enablePrefix ? false
}:

with stdenv.lib;

let
  majorVersion = "1.10";

in stdenv.mkDerivation rec {
  name = "openmpi-${majorVersion}.7";

  src = fetchurl {
    url = "http://www.open-mpi.org/software/ompi/v${majorVersion}/downloads/${name}.tar.bz2";
    sha256 = "142s1vny9gllkq336yafxayjgcirj2jv0ddabj879jgya7hyr2d0";
  };

  buildInputs = [ gfortran ]
    ++ optional (stdenv.isLinux || stdenv.isFreeBSD) libibverbs;

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
    longDescription = "The Open MPI Project is an open source MPI-2 implementation that is developed and maintained by a consortium of academic, research, and industry partners. Open MPI is therefore able to combine the expertise, technologies, and resources from all across the High Performance Computing community in order to build the best MPI library available. Open MPI offers advantages for system and software vendors, application developers and computer science researchers.";
    maintainers = [ stdenv.lib.maintainers.mornfall ];
    platforms = platforms.unix;
  };
}
