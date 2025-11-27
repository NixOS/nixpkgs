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
  # TODO(@connorbaker):
  # When strictDeps is enabled, `cuda_nvcc` is required as the argument to `--with-cuda` in `configureFlags` or else
  # configurePhase fails with `checking for cuda_runtime.h... no`.
  # This is odd, especially given `cuda_runtime.h` is provided by `cuda_cudart.dev`, which is already in `buildInputs`.
  strictDeps = true;

  pname = "ucx";
  version = "1.19.1";

  src = fetchFromGitHub {
    owner = "openucx";
    repo = "ucx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-goANgYuMO1yColKOrqoBOj+yh68OSW7O8Ppng/pd4b0=";
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
    cudaPackages.cuda_nvcc
    cudaPackages.cuda_nvml_dev

  ]
  ++ lib.optionals enableRocm rocmList;

  # NOTE: With `__structuredAttrs` enabled, `LDFLAGS` must be set under `env` so it is assured to be a string;
  # otherwise, we might have forgotten to convert it to a string and Nix would make LDFLAGS a shell variable
  # referring to an array!
  env.LDFLAGS = toString (
    lib.optionals enableCuda [
      # Fake libcuda.so (the real one is deployed impurely)
      "-L${lib.getOutput "stubs" cudaPackages.cuda_cudart}/lib/stubs"
      # Fake libnvidia-ml.so (the real one is deployed impurely)
      "-L${lib.getOutput "stubs" cudaPackages.cuda_nvml_dev}/lib/stubs"
    ]
  );

  configureFlags = [
    "--with-rdmacm=${lib.getDev rdma-core}"
    "--with-dc"
    "--with-rc"
    "--with-dm"
    "--with-verbs=${lib.getDev rdma-core}"
  ]
  ++ lib.optionals enableCuda [ "--with-cuda=${cudaPackages.cuda_nvcc}" ]
  ++ lib.optionals enableRocm [ "--with-rocm=${rocm}" ];

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
