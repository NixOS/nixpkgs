{ lib, stdenv, fetchurl, removeReferencesTo, gfortran, perl, libnl
, rdma-core, zlib, numactl, libevent, hwloc, targetPackages, symlinkJoin
, libpsm2, libfabric, pmix, ucx, ucc, prrte, makeWrapper
, config

# Enable CUDA support
, cudaSupport ? config.cudaSupport, cudaPackages

# Enable the Sun Grid Engine bindings
, enableSGE ? false

# Pass PATH/LD_LIBRARY_PATH to point to current mpirun by default
, enablePrefix ? false

# Enable libfabric support (necessary for Omnipath networks) on x86_64 linux
, fabricSupport ? stdenv.isLinux && stdenv.isx86_64

# Enable Fortran support
, fortranSupport ? true

# AVX/SSE options
# note that opempi fails to build with AVX disabled.
# => everything up to AVX is enabled by default
, enableSse3 ? true
, enableSse4_1 ? true
, enableAvx ? true
, enableAvx2 ? stdenv.hostPlatform.avx2Support
, enableAvx512 ? stdenv.hostPlatform.avx512Support
}:

stdenv.mkDerivation rec {
  pname = "openmpi";
  version = "5.0.3";

  src = with lib.versions; fetchurl {
    url = "https://www.open-mpi.org/software/ompi/v${major version}.${minor version}/downloads/${pname}-${version}.tar.bz2";
    sha256 = "sha256-mQWC8gazqzLpOKoxu/B8Y5No5EBdyhlvq+fw927tqQs=";
  };

  postPatch = ''
    patchShebangs ./

    # This is dynamically detected. Configure does not provide fine grained options
    # We just disable the check in the configure script for now
    ${lib.optionalString (!enableSse3)
      "substituteInPlace configure --replace-fail 'ompi_cv_op_avx_check_sse3=yes' 'ompi_cv_op_avx_check_sse3=no'"}
    ${lib.optionalString (!enableSse4_1)
      "substituteInPlace configure --replace-fail 'ompi_cv_op_avx_check_sse41=yes' 'ompi_cv_op_avx_check_sse41=no'"}
    ${lib.optionalString (!enableAvx)
      "substituteInPlace configure --replace-fail 'ompi_cv_op_avx_check_avx=yes' 'ompi_cv_op_avx_check_avx=no'"}
    ${lib.optionalString (!enableAvx2)
      "substituteInPlace configure --replace-fail 'ompi_cv_op_avx_check_avx2=yes' 'ompi_cv_op_avx_check_avx2=no'"}
    ${lib.optionalString (!enableAvx512)
      "substituteInPlace configure --replace-fail 'ompi_cv_op_avx_check_avx512=yes' 'ompi_cv_op_avx_check_av512=no'"}
  '';

  preConfigure = ''
    # Ensure build is reproducible according to manual
    # https://docs.open-mpi.org/en/v5.0.x/release-notes/general.html#general-notes
    export USER=nixbld
    export HOSTNAME=localhost
    export SOURCE_DATE_EPOCH=0
  '';

  outputs = [ "out" "man" "dev" ];

  buildInputs = [ zlib libevent hwloc ]
    ++ lib.optionals stdenv.isLinux [ numactl pmix ucx ucc prrte ]
    ++ lib.optionals cudaSupport [ cudaPackages.cuda_cudart ]
    ++ lib.optional (stdenv.isLinux || stdenv.isFreeBSD) rdma-core
    ++ lib.optionals fabricSupport [ libpsm2 libfabric ];

  nativeBuildInputs = [ perl removeReferencesTo makeWrapper ]
    ++ lib.optionals cudaSupport [ cudaPackages.cuda_nvcc ]
    ++ lib.optionals fortranSupport [ gfortran ];

  configureFlags = lib.optional (!cudaSupport) "--disable-mca-dso"
    ++ lib.optional stdenv.isLinux "--with-prrte=${lib.getBin prrte}"
    ++ lib.optional (!fortranSupport) "--disable-mpi-fortran"
    ++ lib.optional enableSGE "--with-sge"
    ++ lib.optional enablePrefix "--enable-mpirun-prefix-by-default"
    # TODO: add UCX support, which is recommended to use with cuda for the most robust OpenMPI build
    # https://github.com/openucx/ucx
    # https://www.open-mpi.org/faq/?category=buildcuda
    ++ lib.optionals cudaSupport [ "--with-cuda=${cudaPackages.cuda_cudart}" "--enable-dlopen" ]
    ++ lib.optionals fabricSupport [
      "--with-psm2=${lib.getDev libpsm2}"
      "--with-libfabric=${lib.getDev libfabric}"
      "--with-libfabric-libdir=${lib.getLib libfabric}/lib"
    ];

  enableParallelBuilding = true;

  postInstall = ''
    find $out/lib/ -name "*.la" -exec rm -f \{} \;

    # Move compiler wrappers to $dev
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

  postFixup = ''
    # These reference are caused by hard coded "configure options"
    remove-references-to -t $dev $out/bin/mpirun
    remove-references-to -t $dev $(readlink -f $out/lib/libopen-pal${stdenv.hostPlatform.extensions.library})
    remove-references-to -t $man $(readlink -f $out/lib/libopen-pal${stdenv.hostPlatform.extensions.library})

    # The path to the wrapper is hard coded in libopen-pal.so, which we just cleared.
    wrapProgram $dev/bin/opal_wrapper \
      --set OPAL_INCLUDEDIR $dev/include \
      --set OPAL_PKGDATADIR $dev/share/openmpi

    # default compilers should be identical to the compilers at build time
    for api in mpi shmem; do
      sed -i 's:compiler=.*:compiler=${targetPackages.stdenv.cc}/bin/${targetPackages.stdenv.cc.targetPrefix}cc:' \
        $dev/share/openmpi/''${api}cc-wrapper-data.txt
      sed -i 's:compiler=.*:compiler=${targetPackages.stdenv.cc}/bin/${targetPackages.stdenv.cc.targetPrefix}c++:' \
        $dev/share/openmpi/''${api}c++-wrapper-data.txt
    done
  '' + lib.optionalString fortranSupport ''
    for api in mpi shmem; do
      sed -i 's:compiler=.*:compiler=${gfortran}/bin/${gfortran.targetPrefix}gfortran:'  \
        $dev/share/openmpi/''${api}fort-wrapper-data.txt
    done
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
