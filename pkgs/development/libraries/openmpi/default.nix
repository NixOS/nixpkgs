{ stdenv, fetchurl, fetchpatch, gfortran, perl, libnl
, rdma-core, zlib, numactl, libevent, hwloc

# Enable the Sun Grid Engine bindings
, enableSGE ? false

# Pass PATH/LD_LIBRARY_PATH to point to current mpirun by default
, enablePrefix ? false
}:

let
  version = "4.0.0";

in stdenv.mkDerivation rec {
  name = "openmpi-${version}";

  src = with stdenv.lib.versions; fetchurl {
    url = "http://www.open-mpi.org/software/ompi/v${major version}.${minor version}/downloads/${name}.tar.bz2";
    sha256 = "0srnjwzsmyhka9hhnmqm86qck4w3xwjm8g6sbns58wzbrwv8l2rg";
  };

  patches = [ (fetchpatch {
   # Fix a bug that ignores OMPI_MCA_rmaps_base_oversubscribe (upstream patch).
   # This bug breaks the test from libs, such as scalapack,
   # on machines with less than 4 cores.
   url = https://github.com/open-mpi/ompi/commit/98c8492057e6222af6404b352430d0dd7553d253.patch;
   sha256 = "1mpd8sxxprgfws96qqlzvqf58pn2vv2d0qa8g8cpv773sgw3b3gj";
  }) ];

  postPatch = ''
    patchShebangs ./
  '';

  buildInputs = with stdenv; [ gfortran zlib ]
    ++ lib.optionals isLinux [ libnl numactl libevent hwloc ]
    ++ lib.optional (isLinux || isFreeBSD) rdma-core;

  nativeBuildInputs = [ perl ];

  configureFlags = with stdenv; [ "--disable-mca-dso" ]
    ++ lib.optional isLinux  "--with-libnl=${libnl.dev}"
    ++ lib.optional enableSGE "--with-sge"
    ++ lib.optional enablePrefix "--enable-mpirun-prefix-by-default"
    ;

  enableParallelBuilding = true;

  postInstall = ''
    rm -f $out/lib/*.la
   '';

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://www.open-mpi.org/;
    description = "Open source MPI-3 implementation";
    longDescription = "The Open MPI Project is an open source MPI-3 implementation that is developed and maintained by a consortium of academic, research, and industry partners. Open MPI is therefore able to combine the expertise, technologies, and resources from all across the High Performance Computing community in order to build the best MPI library available. Open MPI offers advantages for system and software vendors, application developers and computer science researchers.";
    maintainers = with maintainers; [ markuskowa ];
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
