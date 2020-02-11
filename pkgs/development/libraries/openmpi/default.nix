{ stdenv, fetchurl, fetchpatch, gfortran, perl, libnl, libfabric, pmix, ucx
, rdma-core, zlib, numactl, libevent, hwloc, pkgsTargetTarget, symlinkJoin

# Enable CUDA support
, cudaSupport ? false, cudatoolkit ? null

# Enable the Sun Grid Engine bindings
, enableSGE ? false

# Pass PATH/LD_LIBRARY_PATH to point to current mpirun by default
, enablePrefix ? false
}:

assert !cudaSupport || cudatoolkit != null;

let
  version = "4.0.2";

  cudatoolkit_joined = symlinkJoin {
    name = "${cudatoolkit.name}-unsplit";
    paths = [ cudatoolkit.out cudatoolkit.lib ];
  };

in stdenv.mkDerivation rec {
  pname = "openmpi";
  inherit version;

  src = with stdenv.lib.versions; fetchurl {
    url = "https://www.open-mpi.org/software/ompi/v${major version}.${minor version}/downloads/${pname}-${version}.tar.bz2";
    sha256 = "0ms0zvyxyy3pnx9qwib6zaljyp2b3ixny64xvq3czv3jpr8zf2wh";
  };

  # TODO: Remove these, when a new release gets out
  patches = [
    (fetchpatch { name = "ucx-1.8-compat-1"; url = "https://github.com/open-mpi/ompi/commit/526775dfd7ad75c308532784de4fb3ffed25458f.patch"; sha256 = "1zfr7ym4303dsnnjqfc1qbnfs0izd8bazxfl57p3dhqsiznd734r"; })
    (fetchpatch { name = "ucx-1.8-compat-2"; url = "https://github.com/open-mpi/ompi/commit/a3026c016a6a8be379f62585b6ddc070175c8106.patch"; sha256 = "04qa1fzx7fsbagc38irs6ilqqnhnwx5ncdslmypzmamrm67v4g00"; })
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

  buildInputs = with stdenv; [ gfortran zlib libfabric pmix ucx ]
    ++ lib.optionals isLinux [ libnl numactl ]
    ++ lib.optionals cudaSupport [ cudatoolkit ]
    ++ [ libevent hwloc ]
    ++ lib.optional (isLinux || isFreeBSD) rdma-core;

  nativeBuildInputs = [ perl ];

  configureFlags = with stdenv; [
    "--with-cma"
    "--with-hwloc=${hwloc.dev}"
    "--with-ofi=${libfabric}"
    "--with-pmi=${pmix}"
    "--with-pmix=${pmix} --enable-install-libpmix"
    "--with-ucx=${ucx}"
    ]
    ++ lib.optional (!cudaSupport) "--disable-mca-dso"
    ++ lib.optional isLinux  "--with-libnl=${libnl.dev}"
    ++ lib.optional enableSGE "--with-sge"
    ++ lib.optional enablePrefix "--enable-mpirun-prefix-by-default"
    ++ lib.optionals cudaSupport [ "--with-cuda=${cudatoolkit_joined}" "--enable-dlopen" ]
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

  passthru = {
    inherit cudaSupport cudatoolkit;
  };

  meta = with stdenv.lib; {
    homepage = https://www.open-mpi.org/;
    description = "Open source MPI-3 implementation";
    longDescription = "The Open MPI Project is an open source MPI-3 implementation that is developed and maintained by a consortium of academic, research, and industry partners. Open MPI is therefore able to combine the expertise, technologies, and resources from all across the High Performance Computing community in order to build the best MPI library available. Open MPI offers advantages for system and software vendors, application developers and computer science researchers.";
    maintainers = with maintainers; [ markuskowa ];
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
