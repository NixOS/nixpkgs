{ lib, stdenv, fetchurl, gfortran, perl, libnl
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
}:

stdenv.mkDerivation rec {
  pname = "openmpi";
  version = "5.0.0rc13";

  src = with lib.versions; fetchurl {
    url = "https://www.open-mpi.org/software/ompi/v${major version}.${minor version}/downloads/${pname}-${version}.tar.bz2";
    sha256 = "sha256-tYhYAv5dOdTzWStwpUi5u4PdkBUr9PrUtyLLCNF+Urs=";
  };

  postPatch = ''
    patchShebangs ./
  '';

  preConfigure = ''
    # Ensure build is reproducible according to manual
    # https://docs.open-mpi.org/en/v5.0.x/release-notes/general.html#general-notes
    export USER=nixbld
    export HOSTNAME=localhost
  '';

  outputs = [ "out" "man" ];

  buildInputs = [ zlib ]
    ++ lib.optionals stdenv.isLinux [ libnl numactl pmix ucx ucc ]
    ++ lib.optionals cudaSupport [ cudaPackages.cuda_cudart ]
    ++ [ libevent hwloc ]
    ++ lib.optional (stdenv.isLinux || stdenv.isFreeBSD) rdma-core
    ++ lib.optionals fabricSupport [ libpsm2 libfabric ];

  nativeBuildInputs = [ perl ]
    ++ lib.optionals cudaSupport [ cudaPackages.cuda_nvcc ]
    ++ lib.optionals fortranSupport [ gfortran ];

  configureFlags = lib.optional (!cudaSupport) "--disable-mca-dso"
    ++ lib.optional (!fortranSupport) "--disable-mpi-fortran"
    ++ lib.optionals stdenv.isLinux  [
      "--with-libnl=${lib.getDev libnl}"
      "--with-pmix=${lib.getDev pmix}"
      "--with-pmix-libdir=${pmix}/lib"
    ] ++ lib.optional enableSGE "--with-sge"
    ++ lib.optional enablePrefix "--enable-mpirun-prefix-by-default"
    # TODO: add UCX support, which is recommended to use with cuda for the most robust OpenMPI build
    # https://github.com/openucx/ucx
    # https://www.open-mpi.org/faq/?category=buildcuda
    ++ lib.optionals cudaSupport [ "--with-cuda=${cudaPackages.cuda_cudart}" "--enable-dlopen" ]
    ++ lib.optionals fabricSupport [ "--with-psm2=${lib.getDev libpsm2}" "--with-libfabric=${lib.getDev libfabric}" ]
    ;

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
