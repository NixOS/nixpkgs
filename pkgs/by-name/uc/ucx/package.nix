{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  doxygen,
  numactl,
  rdma-core,
  libbfd,
  libiberty,
  perl,
  zlib,
  symlinkJoin,
  pkg-config,
  config,
  autoAddDriverRunpath,
  enableCuda ? config.cudaSupport,
  cudaPackages,
  enableRocm ? config.rocmSupport,
  rocmPackages,
}:

let
  rocmList = with rocmPackages; [
    rocm-core
    rocm-runtime
    rocm-device-libs
    clr
  ];

  rocm = symlinkJoin {
    name = "rocm";
    paths = rocmList;
  };
in
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "ucx";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "openucx";
    repo = "ucx";
    tag = "v${finalAttrs.version}";
    # Otherwise compilation fails with:
    #   fatal error: gpunetio/common/doca_gpunetio_verbs_def.h: No such file or directory
    fetchSubmodules = true;
    hash = "sha256-R/uUjkYLPtY9c3vZWrkzKaSgK9Z/cppJCwQ1V1cuwPc=";
  };

  # UCX uses the `#pragma omp master` declaration which is deprecated since
  # OpenMP 5.1. Since UCX builds with -Werror by default, this causes build
  # failures in GCC 16 which introduced the `deprecated-openmp` warning.
  # Accordingly, we replace it with the new `#pragma omp masked` version in
  # compilers which support OpenMP 5.1.
  # https://github.com/openucx/ucx/pull/11697
  patches = [ ./deprecated-openmp-pragma.patch ];

  postPatch = ''
    patchShebangs config/nvcc_wrap.sh
    substituteInPlace config/m4/fuse3.m4 src/uct/sm/scopy/knem/configure.m4 \
      --replace-fail 'pkg-config --' '"$PKG_CONFIG" --'
  '';

  outputs = [
    "out"
    "doc"
    "dev"
  ];

  nativeBuildInputs = [
    autoreconfHook
    doxygen
    pkg-config
  ]
  ++ lib.optionals enableCuda [
    cudaPackages.cuda_nvcc
    autoAddDriverRunpath
  ];

  buildInputs = [
    libbfd
    libiberty
    numactl
    perl
    rdma-core
    zlib
  ]
  ++ lib.optionals enableCuda [
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvml_dev
  ]
  ++ lib.optionals enableRocm rocmList;

  # NOTE: With `__structuredAttrs` enabled, `LDFLAGS` must be set under `env` so it is assured to be a string;
  # otherwise, we might have forgotten to convert it to a string and Nix would make LDFLAGS a shell variable
  # referring to an array!
  env.LDFLAGS = toString (
    lib.optionals enableCuda [
      # Fake libcuda.so (the real one is deployed impurely)
      "-L${lib.getOutput cudaPackages.cuda_cudart.outputStubs cudaPackages.cuda_cudart}/lib/stubs"
      # Fake libnvidia-ml.so (the real one is deployed impurely)
      "-L${lib.getOutput cudaPackages.cuda_nvml_dev.outputStubs cudaPackages.cuda_nvml_dev}/lib/stubs"
    ]
  );

  configureFlags = [
    "--with-rdmacm=${lib.getDev rdma-core}"
    "--with-dc"
    "--with-rc"
    "--with-dm"
    "--with-verbs=${lib.getDev rdma-core}"
  ]
  ++ lib.optionals enableCuda [
    # The toolkit root supplies HOST headers/libraries; find BUILD's NVCC on PATH.
    "--with-cuda=${lib.getDev cudaPackages.cuda_cudart}"
    "--with-nvcc-gencode=${cudaPackages.flags.gencodeString}"
  ]
  ++ lib.optionals enableRocm [ "--with-rocm=${rocm}" ];

  postInstall = ''
    find $out/lib/ -name "*.la" -exec rm -f \{} \;

    moveToOutput bin/ucx_info $dev

    moveToOutput share/ucx/examples $doc
  '';

  enableParallelBuilding = true;

  # Cross installs cannot run HOST's shared-library cache updater on BUILD.
  ${if stdenv.buildPlatform != stdenv.hostPlatform then "installFlags" else null} = [
    "LIBTOOLFLAGS=--no-finish"
  ];

  meta = {
    description = "Unified Communication X library";
    homepage = "https://www.openucx.org";
    downloadPage = "https://github.com/openucx/ucx";
    changelog = "https://github.com/openucx/ucx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    # LoongArch64 is not supported.
    # See: https://github.com/openucx/ucx/issues/9873
    badPlatforms = lib.platforms.loongarch64;
    maintainers = with lib.maintainers; [ markuskowa ];
  };
})
