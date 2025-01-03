{
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
  inherit (lib.lists) optionals;
  inherit (lib.strings) concatStringsSep;

  inherit (cudaPackages)
    cuda_cccl
    cuda_cudart
    cuda_nvcc
    cudaFlags
    ;
in
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  # TODO: When strictDeps is enabled, the CUDA build fails during configurePhase because it can't find all the CUDA
  # dependencies. As such, we hold off on enabling strictDeps until CUDA compilation works.
  # https://github.com/openucx/ucc/blob/0c0fc21559835044ab107199e334f7157d6a0d3d/config/m4/cuda.m4
  strictDeps = false;

  pname = "ucc";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "openucx";
    repo = "ucc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xcJLYktkxNK2ewWRgm8zH/dMaIoI+9JexuswXi7MpAU=";
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
          "${stdenv.shell}"
    done
  '';

  nativeBuildInputs = [
    autoconf
    automake
    libtool
  ] ++ optionals enableCuda [ cuda_nvcc ];

  buildInputs =
    [ ucx ]
    ++ optionals enableCuda [
      cuda_cccl
      cuda_cudart
    ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags =
    optionals enableSse41 [ "--with-sse41" ]
    ++ optionals enableSse42 [ "--with-sse42" ]
    ++ optionals enableAvx [ "--with-avx" ]
    ++ optionals enableCuda [
      "--with-cuda=${cuda_cudart}"
      "--with-nvcc-gencode=${concatStringsSep " " cudaFlags.gencode}"
    ];

  postInstall = ''
    find "$out/lib/" -name "*.la" -exec rm -f \{} \;

    moveToOutput bin/ucc_info "$dev"
  '';

  meta = with lib; {
    description = "Collective communication operations API";
    mainProgram = "ucc_info";
    license = licenses.bsd3;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
})
