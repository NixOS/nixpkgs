{ stdenv, fetchurl, fetchpatch, gfortran, perl, libnl
, rdma-core, zlib, numactl, libevent, hwloc, pkgsTargetTarget

# Enable the Sun Grid Engine bindings
, enableSGE ? false

# Pass PATH/LD_LIBRARY_PATH to point to current mpirun by default
, enablePrefix ? false
}:

let
  version = "4.0.1";

in stdenv.mkDerivation rec {
  pname = "openmpi";
  inherit version;

  src = with stdenv.lib.versions; fetchurl {
    url = "https://www.open-mpi.org/software/ompi/v${major version}.${minor version}/downloads/${pname}-${version}.tar.bz2";
    sha256 = "02cpzcp113gj5hb0j2xc0cqma2fn04i2i0bzf80r71120p9bdryc";
  };

  patches = [
    (fetchpatch {
      name = "openmpi-mca_btl_vader_component_close-segfault.patch";
      url = "https://github.com/open-mpi/ompi/pull/6526.patch";
      sha256 = "0s7ac9rkcj3fi6ampkvy76njlj478yyr4zvypjc7licy6dgr595x";
    })
  ];

  postPatch = ''
    patchShebangs ./

    # Ensure build is reproducible
    ts=`date -d @$SOURCE_DATE_EPOCH`
    sed -i 's/OPAL_CONFIGURE_USER=.*/OPAL_CONFIGURE_USER="nixbld"/' configure
    sed -i 's/OPAL_CONFIGURE_HOST=.*/OPAL_CONFIGURE_HOST="localhost"/' configure
    sed -i "s/OPAL_CONFIGURE_DATE=.*/OPAL_CONFIGURE_DATE=\"$ts\"/" configure
    find -name "Makefile.in" -exec sed -i "s/\`date\`/$ts/" \{} \;
  '';

  buildInputs = with stdenv; [ gfortran zlib ]
    ++ lib.optionals isLinux [ libnl numactl ]
    ++ [ libevent hwloc ]
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

  postFixup = ''
    # default compilers should be indentical to the
    # compilers at build time

    sed -i 's:compiler=.*:compiler=${pkgsTargetTarget.stdenv.cc}/bin/${pkgsTargetTarget.stdenv.cc.targetPrefix}cc:' \
      $out/share/openmpi/mpicc-wrapper-data.txt

    sed -i 's:compiler=.*:compiler=${pkgsTargetTarget.stdenv.cc}/bin/${pkgsTargetTarget.stdenv.cc.targetPrefix}cc:' \
       $out/share/openmpi/ortecc-wrapper-data.txt

    sed -i 's:compiler=.*:compiler=${pkgsTargetTarget.stdenv.cc}/bin/${pkgsTargetTarget.stdenv.cc.targetPrefix}c++:' \
       $out/share/openmpi/mpic++-wrapper-data.txt

    sed -i 's:compiler=.*:compiler=${pkgsTargetTarget.gfortran}/bin/${pkgsTargetTarget.gfortran.targetPrefix}gfortran:'  \
       $out/share/openmpi/mpifort-wrapper-data.txt
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://www.open-mpi.org/;
    description = "Open source MPI-3 implementation";
    longDescription = "The Open MPI Project is an open source MPI-3 implementation that is developed and maintained by a consortium of academic, research, and industry partners. Open MPI is therefore able to combine the expertise, technologies, and resources from all across the High Performance Computing community in order to build the best MPI library available. Open MPI offers advantages for system and software vendors, application developers and computer science researchers.";
    maintainers = with maintainers; [ markuskowa ];
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
