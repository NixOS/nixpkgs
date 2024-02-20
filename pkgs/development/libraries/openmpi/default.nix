{ lib, stdenv, fetchurl, gfortran, perl
, rdma-core, zlib, numactl, libevent, hwloc, targetPackages, symlinkJoin
, libpsm2, libfabric, pmix, ucx, ucc
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
, enableSse3 ? stdenv.hostPlatform.sse3Support
, enableSse4_1 ? stdenv.hostPlatform.sse4_1Support
, enableAvx ? true #stdenv.hostPlatform.avxSupport
, enableAvx2 ? stdenv.hostPlatform.avx2Support
, enableAvx512 ? stdenv.hostPlatform.avx512Support
}:

stdenv.mkDerivation rec {
  pname = "openmpi";
  version = "5.0.2";

  src = with lib.versions; fetchurl {
    url = "https://www.open-mpi.org/software/ompi/v${major version}.${minor version}/downloads/${pname}-${version}.tar.bz2";
    sha256 = "sha256-7katju7iw/9wdyFgv/h3y/OMMwoLw7PdyBFkizOWaY8=";
  };

  postPatch = ''
    patchShebangs ./

    # This is dynamically detected. Configure does not provide fine grained options
    # We just disable the check in the configure script for now
    ${lib.optionalString (!enableSse3)
      "substituteInPlace configure --replace 'ompi_cv_op_avx_check_sse3=yes' 'ompi_cv_op_avx_check_sse3=no'"}
    ${lib.optionalString (!enableSse4_1)
      "substituteInPlace configure --replace 'ompi_cv_op_avx_check_sse41=yes' 'ompi_cv_op_avx_check_sse41=no'"}
    ${lib.optionalString (!enableAvx)
      "substituteInPlace configure --replace 'ompi_cv_op_avx_check_avx=yes' 'ompi_cv_op_avx_check_avx=no'"}
    ${lib.optionalString (!enableAvx2)
      "substituteInPlace configure --replace 'ompi_cv_op_avx_check_avx2=yes' 'ompi_cv_op_avx_check_avx2=no'"}
    ${lib.optionalString (!enableAvx512)
      "substituteInPlace configure --replace 'ompi_cv_op_avx_check_avx512=yes' 'ompi_cv_op_avx_check_av512=no'"}
  '';

  preConfigure = ''
    # Ensure build is reproducible according to manual
    # https://docs.open-mpi.org/en/v5.0.x/release-notes/general.html#general-notes
    export USER=nixbld
    export HOSTNAME=localhost
    export SOURCE_DATE_EPOCH=0
  '';

  outputs = [ "out" "man" ];

  buildInputs = [ zlib libevent hwloc ]
    ++ lib.optionals stdenv.isLinux [ numactl pmix ucx ucc ]
    ++ lib.optionals cudaSupport [ cudaPackages.cuda_cudart ]
    ++ lib.optional (stdenv.isLinux || stdenv.isFreeBSD) rdma-core
    ++ lib.optionals fabricSupport [ libpsm2 libfabric ];

  nativeBuildInputs = [ perl ]
    ++ lib.optionals cudaSupport [ cudaPackages.cuda_nvcc ]
    ++ lib.optionals fortranSupport [ gfortran ];

  configureFlags = lib.optional (!cudaSupport) "--disable-mca-dso"
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
   '';

  postFixup = ''
    # default compilers should be indentical to the
    # compilers at build time

    for cfg in mpicc shmemcc; do
      sed -i 's:compiler=.*:compiler=${targetPackages.stdenv.cc}/bin/${targetPackages.stdenv.cc.targetPrefix}cc:' \
        "$out/share/openmpi/$cfg-wrapper-data.txt"
    done

    for cfg in mpic++ shmemc++; do
      sed -i 's:compiler=.*:compiler=${targetPackages.stdenv.cc}/bin/${targetPackages.stdenv.cc.targetPrefix}c++:' \
        "$out/share/openmpi/$cfg-wrapper-data.txt"
    done
  '' + lib.optionalString fortranSupport ''
    for cfg in mpifort shmemfort; do
      sed -i 's:compiler=.*:compiler=${gfortran}/bin/${gfortran.targetPrefix}gfortran:'  \
         "$out/share/openmpi/$cfg-wrapper-data.txt"
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
