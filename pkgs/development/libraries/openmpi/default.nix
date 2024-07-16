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

stdenv.mkDerivation (finalAttrs: {
  pname = "openmpi";
  version = "4.1.6";

  src = fetchurl {
    url = "https://www.open-mpi.org/software/ompi/v${lib.versions.majorMinor finalAttrs.version}/downloads/${finalAttrs.pname}-${finalAttrs.version}.tar.bz2";
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
    [
      zlib
      libevent
      hwloc
    ]
    ++ lib.optionals stdenv.isLinux [
      libnl
      numactl
      pmix
      ucx
      ucc
    ]
    ++ lib.optionals cudaSupport [ cudaPackages.cuda_cudart ]
    ++ lib.optionals (stdenv.isLinux || stdenv.isFreeBSD) [ rdma-core ]
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

  configureFlags = [
    (lib.enableFeature cudaSupport "mca-dso")
    (lib.enableFeature fortranSupport "mpi-fortran")
    (lib.withFeatureAs stdenv.isLinux "libnl" (lib.getDev libnl))
    (lib.withFeatureAs stdenv.isLinux "pmix" (lib.getDev pmix))
    (lib.withFeatureAs stdenv.isLinux "pmix-libdir" "${lib.getLib pmix}/lib")
    (lib.enableFeature stdenv.isLinux "mpi-cxx")
    (lib.withFeature enableSGE "sge")
    (lib.enableFeature enablePrefix "mpirun-prefix-by-default")
    # TODO: add UCX support, which is recommended to use with cuda for the most robust OpenMPI build
    # https://github.com/openucx/ucx
    # https://www.open-mpi.org/faq/?category=buildcuda
    (lib.withFeatureAs cudaSupport "cuda" (lib.getDev cudaPackages.cuda_cudart))
    (lib.enableFeature cudaSupport "dlopen")
    (lib.withFeatureAs fabricSupport "psm2" (lib.getDev libpsm2))
    (lib.withFeatureAs fabricSupport "libfabric" (lib.getDev libfabric))
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
      remove-references-to -t "''${!outputDev}" $(readlink -f $out/lib/libopen-pal${stdenv.hostPlatform.extensions.sharedLibrary})
      remove-references-to -t "''${!outputMan}" $(readlink -f $out/lib/libopen-pal${stdenv.hostPlatform.extensions.sharedLibrary})

      # The path to the wrapper is hard coded in libopen-pal.so, which we just cleared.
      wrapProgram "''${!outputDev}/bin/opal_wrapper" \
        --set OPAL_INCLUDEDIR "''${!outputDev}/include" \
        --set OPAL_PKGDATADIR "''${!outputDev}/share/openmpi"

      # default compilers should be indentical to the
      # compilers at build time

      echo "''${!outputDev}/share/openmpi/mpicc-wrapper-data.txt"
      sed -i 's:compiler=.*:compiler=${targetPackages.stdenv.cc}/bin/${targetPackages.stdenv.cc.targetPrefix}cc:' \
        ''${!outputDev}/share/openmpi/mpicc-wrapper-data.txt

      echo "''${!outputDev}/share/openmpi/ortecc-wrapper-data.txt"
      sed -i 's:compiler=.*:compiler=${targetPackages.stdenv.cc}/bin/${targetPackages.stdenv.cc.targetPrefix}cc:' \
         ''${!outputDev}/share/openmpi/ortecc-wrapper-data.txt

      echo "''${!outputDev}/share/openmpi/mpic++-wrapper-data.txt"
      sed -i 's:compiler=.*:compiler=${targetPackages.stdenv.cc}/bin/${targetPackages.stdenv.cc.targetPrefix}c++:' \
         ''${!outputDev}/share/openmpi/mpic++-wrapper-data.txt
    ''
    + lib.optionalString fortranSupport ''

      echo "''${!outputDev}/share/openmpi/mpifort-wrapper-data.txt"
      sed -i 's:compiler=.*:compiler=${gfortran}/bin/${gfortran.targetPrefix}gfortran:'  \
         ''${!outputDev}/share/openmpi/mpifort-wrapper-data.txt

    '';

  doCheck = true;

  passthru = {
    inherit cudaSupport;
    cudatoolkit = cudaPackages.cudatoolkit; # For backward compatibility only
  };

  meta = {
    homepage = "https://www.open-mpi.org/";
    description = "Open source MPI-3 implementation";
    longDescription = "The Open MPI Project is an open source MPI-3 implementation that is developed and maintained by a consortium of academic, research, and industry partners. Open MPI is therefore able to combine the expertise, technologies, and resources from all across the High Performance Computing community in order to build the best MPI library available. Open MPI offers advantages for system and software vendors, application developers and computer science researchers.";
    maintainers = with lib.maintainers; [ markuskowa ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
