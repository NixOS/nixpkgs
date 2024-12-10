{
  lib,
  stdenv,
  fetchurl,
  removeReferencesTo,
  gfortran,
  perl,
  libnl,
  rdma-core,
  zlib,
  numactl,
  libevent,
  hwloc,
  targetPackages,
  symlinkJoin,
  libpsm2,
  libfabric,
  pmix,
  ucx,
  ucc,
  makeWrapper,
  config,
  # Enable CUDA support
  cudaSupport ? config.cudaSupport,
  cudaPackages,

  # Enable the Sun Grid Engine bindings
  enableSGE ? false,

  # Pass PATH/LD_LIBRARY_PATH to point to current mpirun by default
  enablePrefix ? false,

  # Enable libfabric support (necessary for Omnipath networks) on x86_64 linux
  fabricSupport ? stdenv.isLinux && stdenv.isx86_64,

  # Enable Fortran support
  fortranSupport ? true,
}:

stdenv.mkDerivation rec {
  pname = "openmpi";
  version = "4.1.6";

  src =
    with lib.versions;
    fetchurl {
      url = "https://www.open-mpi.org/software/ompi/v${major version}.${minor version}/downloads/${pname}-${version}.tar.bz2";
      sha256 = "sha256-90CZRIVRbetjtTEa8SLCZRefUyig2FelZ7hdsAsR5BU=";
    };

  postPatch = ''
    patchShebangs ./

    # Ensure build is reproducible
    ts=`date -d @$SOURCE_DATE_EPOCH`
    sed -i 's/OPAL_CONFIGURE_USER=.*/OPAL_CONFIGURE_USER="nixbld"/' configure
    sed -i 's/OPAL_CONFIGURE_HOST=.*/OPAL_CONFIGURE_HOST="localhost"/' configure
    sed -i "s/OPAL_CONFIGURE_DATE=.*/OPAL_CONFIGURE_DATE=\"$ts\"/" configure
    find -name "Makefile.in" -exec sed -i "s/\`date\`/$ts/" \{} \;
  '';

  outputs = [
    "out"
    "man"
    "dev"
  ];

  buildInputs =
    [ zlib ]
    ++ lib.optionals stdenv.isLinux [
      libnl
      numactl
      pmix
      ucx
      ucc
    ]
    ++ lib.optionals cudaSupport [ cudaPackages.cuda_cudart ]
    ++ [
      libevent
      hwloc
    ]
    ++ lib.optional (stdenv.isLinux || stdenv.isFreeBSD) rdma-core
    ++ lib.optionals fabricSupport [
      libpsm2
      libfabric
    ];

  nativeBuildInputs =
    [
      perl
      removeReferencesTo
      makeWrapper
    ]
    ++ lib.optionals cudaSupport [ cudaPackages.cuda_nvcc ]
    ++ lib.optionals fortranSupport [ gfortran ];

  configureFlags =
    lib.optional (!cudaSupport) "--disable-mca-dso"
    ++ lib.optional (!fortranSupport) "--disable-mpi-fortran"
    ++ lib.optionals stdenv.isLinux [
      "--with-libnl=${lib.getDev libnl}"
      "--with-pmix=${lib.getDev pmix}"
      "--with-pmix-libdir=${pmix}/lib"
      "--enable-mpi-cxx"
    ]
    ++ lib.optional enableSGE "--with-sge"
    ++ lib.optional enablePrefix "--enable-mpirun-prefix-by-default"
    # TODO: add UCX support, which is recommended to use with cuda for the most robust OpenMPI build
    # https://github.com/openucx/ucx
    # https://www.open-mpi.org/faq/?category=buildcuda
    ++ lib.optionals cudaSupport [
      "--with-cuda=${cudaPackages.cuda_cudart}"
      "--enable-dlopen"
    ]
    ++ lib.optionals fabricSupport [
      "--with-psm2=${lib.getDev libpsm2}"
      "--with-libfabric=${lib.getDev libfabric}"
    ];

  enableParallelBuilding = true;

  postInstall = ''
    find $out/lib/ -name "*.la" -exec rm -f \{} \;

    for f in mpi shmem osh; do
      for i in f77 f90 CC c++ cxx cc fort; do
        moveToOutput "bin/$f$i" "''${!outputDev}"
        echo "move $fi$i"
        moveToOutput "share/openmpi/$f$i-wrapper-data.txt" "''${!outputDev}"
      done
    done

    for i in ortecc orte-info ompi_info oshmem_info opal_wrapper; do
      moveToOutput "bin/$i" "''${!outputDev}"
    done

    moveToOutput "share/openmpi/ortecc-wrapper-data.txt" "''${!outputDev}"
  '';

  postFixup =
    ''
      remove-references-to -t $dev $(readlink -f $out/lib/libopen-pal${stdenv.hostPlatform.extensions.sharedLibrary})
      remove-references-to -t $man $(readlink -f $out/lib/libopen-pal${stdenv.hostPlatform.extensions.sharedLibrary})

      # The path to the wrapper is hard coded in libopen-pal.so, which we just cleared.
      wrapProgram $dev/bin/opal_wrapper \
        --set OPAL_INCLUDEDIR $dev/include \
        --set OPAL_PKGDATADIR $dev/share/openmpi

      # default compilers should be indentical to the
      # compilers at build time

      echo "$dev/share/openmpi/mpicc-wrapper-data.txt"
      sed -i 's:compiler=.*:compiler=${targetPackages.stdenv.cc}/bin/${targetPackages.stdenv.cc.targetPrefix}cc:' \
        $dev/share/openmpi/mpicc-wrapper-data.txt

      echo "$dev/share/openmpi/ortecc-wrapper-data.txt"
      sed -i 's:compiler=.*:compiler=${targetPackages.stdenv.cc}/bin/${targetPackages.stdenv.cc.targetPrefix}cc:' \
         $dev/share/openmpi/ortecc-wrapper-data.txt

      echo "$dev/share/openmpi/mpic++-wrapper-data.txt"
      sed -i 's:compiler=.*:compiler=${targetPackages.stdenv.cc}/bin/${targetPackages.stdenv.cc.targetPrefix}c++:' \
         $dev/share/openmpi/mpic++-wrapper-data.txt
    ''
    + lib.optionalString fortranSupport ''

      echo "$dev/share/openmpi/mpifort-wrapper-data.txt"
      sed -i 's:compiler=.*:compiler=${gfortran}/bin/${gfortran.targetPrefix}gfortran:'  \
         $dev/share/openmpi/mpifort-wrapper-data.txt

    '';

  doCheck = true;

  passthru = {
    inherit cudaSupport;
    cudatoolkit = cudaPackages.cudatoolkit; # For backward compatibility only
  };

  meta = with lib; {
    homepage = "https://www.open-mpi.org/";
    description = "Open source MPI-3 implementation";
    longDescription = "The Open MPI Project is an open source MPI-3 implementation that is developed and maintained by a consortium of academic, research, and industry partners. Open MPI is therefore able to combine the expertise, technologies, and resources from all across the High Performance Computing community in order to build the best MPI library available. Open MPI offers advantages for system and software vendors, application developers and computer science researchers.";
    maintainers = with maintainers; [ markuskowa ];
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
