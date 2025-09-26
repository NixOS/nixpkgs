inputs@{
  autoconf,
  automake,
  config,
  cudaPackages,
  fetchFromGitHub,
  lib,
  libtool,
  stdenv,
  ucx,
  # Configuration options
  enableAvx ? stdenv.hostPlatform.avxSupport,
  enableCuda ? config.cudaSupport,
  enableSse41 ? stdenv.hostPlatform.sse4_1Support,
  enableSse42 ? stdenv.hostPlatform.sse4_2Support,
}:
let
  inherit (lib.attrsets) getLib;
  inherit (lib.lists) optionals;
  inherit (lib.strings) concatStringsSep;

  inherit (cudaPackages)
    cuda_cccl
    cuda_cudart
    cuda_nvcc
    cuda_nvml_dev
    flags
    nccl
    ;

  stdenv = throw "Use effectiveStdenv instead";
  effectiveStdenv = if enableCuda then cudaPackages.backendStdenv else inputs.stdenv;
in
effectiveStdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  # TODO(@connorbaker):
  # When strictDeps is enabled, `cuda_nvcc` is required as the argument to `--with-cuda` in `configureFlags` or else
  # configurePhase fails with `checking for cuda_runtime.h... no`.
  # This is odd, especially given `cuda_runtime.h` is provided by `cuda_cudart.dev`, which is already in `buildInputs`.
  strictDeps = true;

  pname = "ucc";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "openucx";
    repo = "ucc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gNLpcVvOsBCR0+KL21JSdWZyt/Z8EjQQTiHJw5vzOOo=";
  };

  outputs = [
    "out"
    "dev"
  ];

  enableParallelBuilding = true;

  # NOTE: We use --replace-quiet because not all Makefile.am files contain /bin/bash.
  postPatch = ''
    for comp in $(find src/components -name Makefile.am); do
      substituteInPlace "$comp" \
        --replace-quiet \
          "/bin/bash" \
          "${effectiveStdenv.shell}"
    done
  '';

  nativeBuildInputs = [
    autoconf
    automake
    libtool
  ]
  ++ optionals enableCuda [ cuda_nvcc ];

  buildInputs = [
    ucx
  ]
  ++ optionals enableCuda [
    cuda_cccl
    cuda_cudart
    cuda_nvml_dev
    nccl
  ];

  # NOTE: With `__structuredAttrs` enabled, `LDFLAGS` must be set under `env` so it is assured to be a string;
  # otherwise, we might have forgotten to convert it to a string and Nix would make LDFLAGS a shell variable
  # referring to an array!
  env.LDFLAGS = builtins.toString (
    optionals enableCuda [
      # Fake libnvidia-ml.so (the real one is deployed impurely)
      "-L${getLib cuda_nvml_dev}/lib/stubs"
    ]
  );

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags =
    optionals enableSse41 [ "--with-sse41" ]
    ++ optionals enableSse42 [ "--with-sse42" ]
    ++ optionals enableAvx [ "--with-avx" ]
    ++ optionals enableCuda [
      "--with-cuda=${cuda_nvcc}"
      "--with-nvcc-gencode=${concatStringsSep " " flags.gencode}"
    ];

  postInstall = ''
    find "$out/lib/" -name "*.la" -exec rm -f \{} \;

    moveToOutput bin/ucc_info "$dev"
  '';

  meta = with lib; {
    description = "Collective communication operations API";
    homepage = "https://openucx.github.io/ucc/";
    mainProgram = "ucc_info";
    license = licenses.bsd3;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
})
