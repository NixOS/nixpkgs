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
  pname = "ucx";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "openucx";
    repo = "ucx";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-n3xJmbvUXZzfhotOBJRyH2OEL4NFZIKyB808HwEQSYo=";
  };

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

  LDFLAGS = lib.optionals enableCuda [
    # Fake libnvidia-ml.so (the real one is deployed impurely)
    "-L${lib.getLib cudaPackages.cuda_nvml_dev}/lib/stubs"
  ];

  configureFlags = [
    "--with-rdmacm=${lib.getDev rdma-core}"
    "--with-dc"
    "--with-rc"
    "--with-dm"
    "--with-verbs=${lib.getDev rdma-core}"
  ]
  ++ lib.optionals enableCuda [ "--with-cuda=${cudaPackages.cuda_cudart}" ]
  ++ lib.optional enableRocm "--with-rocm=${rocm}";

  postInstall = ''
    find $out/lib/ -name "*.la" -exec rm -f \{} \;

    moveToOutput bin/ucx_info $dev

    moveToOutput share/ucx/examples $doc
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Unified Communication X library";
    homepage = "https://www.openucx.org";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    # LoongArch64 is not supported.
    # See: https://github.com/openucx/ucx/issues/9873
    badPlatforms = lib.platforms.loongarch64;
    maintainers = with lib.maintainers; [ markuskowa ];
  };
})
