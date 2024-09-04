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
  prrte,
  makeWrapper,
  python3,
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
  # AVX/SSE options. See passthru.defaultAvxOptions for the available options.
  # note that opempi fails to build with AVX disabled, meaning that everything
  # up to AVX is enabled by default.
  avxOptions ? { },
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openmpi";
  version = "5.0.5";

  src = fetchurl {
    url = "https://www.open-mpi.org/software/ompi/v${lib.versions.majorMinor finalAttrs.version}/downloads/openmpi-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-ZYjVfApL0pmiQQP04ZYFGynotV+9pJ4R1bPTIDCjJ3Y=";
  };

  postPatch = ''
    patchShebangs ./

    # This is dynamically detected. Configure does not provide fine grained options
    # We just disable the check in the configure script for now
    ${lib.pipe (finalAttrs.passthru.defaultAvxOptions // avxOptions) [
      (lib.mapAttrsToList (
        option: val: ''
          substituteInPlace configure \
            --replace-fail \
              ompi_cv_op_avx_check_${option}=yes \
              ompi_cv_op_avx_check_${option}=${if val then "yes" else "no"}
        ''
      ))
      (lib.concatStringsSep "\n")
    ]}
  '';

  # Ensure build is reproducible according to manual
  # https://docs.open-mpi.org/en/v5.0.x/release-notes/general.html#general-notes
  env = {
    USER = "nixbld";
    HOSTNAME = "localhost";
    SOURCE_DATE_EPOCH = "0";
  };

  outputs =
    [ "out" ]
    ++ lib.optionals stdenv.isLinux [
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
      prrte
    ]
    ++ lib.optionals cudaSupport [ cudaPackages.cuda_cudart ]
    ++ lib.optionals (stdenv.isLinux || stdenv.isFreeBSD) [ rdma-core ]
    # needed for internal pmix
    ++ lib.optionals (!stdenv.isLinux) [ python3 ]
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
    "--with-pmix=${lib.getDev pmix}"
    "--with-pmix-libdir=${lib.getLib pmix}/lib"
    # Puts a "default OMPI_PRTERUN" value to mpirun / mpiexec executables
    (lib.withFeatureAs stdenv.isLinux "prrte" (lib.getBin prrte))
    (lib.withFeature enableSGE "sge")
    (lib.enableFeature enablePrefix "mpirun-prefix-by-default")
    # TODO: add UCX support, which is recommended to use with cuda for the most robust OpenMPI build
    # https://github.com/openucx/ucx
    # https://www.open-mpi.org/faq/?category=buildcuda
    (lib.withFeatureAs cudaSupport "cuda" (lib.getDev cudaPackages.cuda_cudart))
    (lib.enableFeature cudaSupport "dlopen")
    (lib.withFeatureAs fabricSupport "psm2" (lib.getDev libpsm2))
    (lib.withFeatureAs fabricSupport "ofi" (lib.getDev libfabric))
    # The flag --without-ofi-libdir is not supported from some reason, so we
    # don't use lib.withFeatureAs
  ] ++ lib.optionals fabricSupport [ "--with-ofi-libdir=${lib.getLib libfabric}/lib" ];

  enableParallelBuilding = true;

  postInstall =
    let
      # The file names we need to iterate are a combination of ${p}${s}, and there
      # are 7x3 such options. We use lib.mapCartesianProduct to iterate them all.
      fileNamesToIterate = {
        p = [
          "mpi"
          "shmem"
          "osh"
        ];
        s =
          [
            "CC"
            "c++"
            "cxx"
            "cc"
          ]
          ++ lib.optionals fortranSupport [
            "f77"
            "f90"
            "fort"
          ];
      };
      wrapperDataSubstitutions =
        {
          # The attr key is the filename prefix. The list's 1st value is the
          # compiler=_ line that should be replaced by a compiler=#2 string, where
          # #2 is the 2nd value in the list.
          "cc" = [
            "gcc"
            "${targetPackages.stdenv.cc}/bin/${targetPackages.stdenv.cc.targetPrefix}cc"
          ];
          "c++" = [
            "g++"
            "${targetPackages.stdenv.cc}/bin/${targetPackages.stdenv.cc.targetPrefix}c++"
          ];
        }
        // lib.optionalAttrs fortranSupport {
          "fort" = [
            "gfortran"
            "${targetPackages.gfortran}/bin/${targetPackages.gfortran.targetPrefix}gfortran"
          ];
        };
      # The -wrapper-data.txt files that are not symlinks, need to be iterated as
      # well, here they start withw ${part1}${part2}, and we use
      # lib.mapCartesianProduct as well.
      wrapperDataFileNames = {
        part1 = [
          "mpi"
          "shmem"
        ];
        part2 = builtins.attrNames wrapperDataSubstitutions;
      };
    in
    ''
      find $out/lib/ -name "*.la" -exec rm -f \{} \;

      # The main wrapper that all the rest of the commonly used binaries are
      # symlinked to
      moveToOutput "bin/opal_wrapper" "''${!outputDev}"
      # All of the following files are symlinks to opal_wrapper
      ${lib.pipe fileNamesToIterate [
        (lib.mapCartesianProduct (
          { p, s }:
          ''
            echo "handling ${p}${s}"
            moveToOutput "bin/${p}${s}" "''${!outputDev}"
            moveToOutput "share/openmpi/${p}${s}-wrapper-data.txt" "''${!outputDev}"
          ''
        ))
        (lib.concatStringsSep "\n")
      ]}
      # default compilers should be indentical to the
      # compilers at build time
      ${lib.pipe wrapperDataFileNames [
        (lib.mapCartesianProduct (
          { part1, part2 }:
          # From some reason the Darwin build doesn't include some of these
          # wrapperDataSubstitutions strings and even some of the files. Hence
          # we currently don't perform these substitutions on other platforms,
          # until a Darwin user will care enough about this cross platform
          # related substitution.
          lib.optionalString stdenv.isLinux ''
            substituteInPlace "''${!outputDev}/share/openmpi/${part1}${part2}-wrapper-data.txt" \
              --replace-fail \
                compiler=${lib.elemAt wrapperDataSubstitutions.${part2} 0} \
                compiler=${lib.elemAt wrapperDataSubstitutions.${part2} 1}
          ''
        ))
        (lib.concatStringsSep "\n")
      ]}
      # A symlink to $\{lib.getDev pmix}/bin/pmixcc upstreeam puts here as well
      # from some reason.
      moveToOutput "bin/pcc" "''${!outputDev}"

      # Handle informative binaries about the compilation
      for i in {prte,ompi,oshmem}_info; do
        moveToOutput "bin/$i" "''${!outputDev}"
      done
    '';

  postFixup =
    lib.optionalString (lib.elem "man" finalAttrs.outputs) ''
      remove-references-to -t "''${!outputMan}" $(readlink -f $out/lib/libopen-pal${stdenv.hostPlatform.extensions.sharedLibrary})
    ''
    + lib.optionalString (lib.elem "dev" finalAttrs.outputs) ''
      remove-references-to -t "''${!outputDev}" $out/bin/mpirun
      remove-references-to -t "''${!outputDev}" $(readlink -f $out/lib/libopen-pal${stdenv.hostPlatform.extensions.sharedLibrary})

      # The path to the wrapper is hard coded in libopen-pal.so, which we just cleared.
      wrapProgram "''${!outputDev}/bin/opal_wrapper" \
        --set OPAL_INCLUDEDIR "''${!outputDev}/include" \
        --set OPAL_PKGDATADIR "''${!outputDev}/share/openmpi"
    '';

  doCheck = true;

  passthru = {
    defaultAvxOptions = {
      sse3 = true;
      sse41 = true;
      avx = true;
      avx2 = stdenv.hostPlatform.avx2Support;
      avx512 = stdenv.hostPlatform.avx512Support;
    };
    inherit cudaSupport;
    cudatoolkit = cudaPackages.cudatoolkit; # For backward compatibility only
  };

  meta = {
    homepage = "https://www.open-mpi.org/";
    description = "Open source MPI-3 implementation";
    longDescription = "The Open MPI Project is an open source MPI-3 implementation that is developed and maintained by a consortium of academic, research, and industry partners. Open MPI is therefore able to combine the expertise, technologies, and resources from all across the High Performance Computing community in order to build the best MPI library available. Open MPI offers advantages for system and software vendors, application developers and computer science researchers.";
    maintainers = with lib.maintainers; [
      markuskowa
      doronbehar
    ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
