# NOTE: Though NCCL is called within the cudaPackages package set, we avoid passing in
# the names of dependencies from that package set directly to avoid evaluation errors
# in the case redistributable packages are not available.
{
  lib,
  fetchFromGitHub,
  python3,
  which,
  autoAddDriverRunpath,
  cudaPackages,
  # passthru.updateScript
  gitUpdater,
}:
let
  inherit (cudaPackages)
    backendStdenv
    cuda_cccl
    cuda_cudart
    cuda_nvcc
    flags
    ;
  version = "2.28.7-1";
  hash = "sha256-NM19OiBBGmv3cGoVoRLKSh9Y59hiDoei9NIrRnTqWeA=";
in
backendStdenv.mkDerivation (finalAttrs: {
  pname = "nccl";
  version = version;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nccl";
    rev = "v${finalAttrs.version}";
    hash = hash;
  };

  __structuredAttrs = true;
  strictDeps = true;

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    which
    autoAddDriverRunpath
    python3
    cuda_nvcc
  ];

  buildInputs = [
    cuda_nvcc # crt/host_config.h
    cuda_cudart
    cuda_cccl
  ];

  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-unused-function" ];

  postPatch = ''
    patchShebangs ./src/device/generate.py
    patchShebangs ./src/device/symmetric/generate.py
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "NVCC_GENCODE=${flags.gencodeString}"
    "CUDA_HOME=${cuda_nvcc}"
    "CUDA_LIB=${lib.getLib cuda_cudart}/lib"
    "CUDA_INC=${lib.getDev cuda_cudart}/include"
  ];

  enableParallelBuilding = true;

  postFixup = ''
    moveToOutput lib/libnccl_static.a $dev
  '';

  passthru.updateScript = gitUpdater {
    inherit (finalAttrs) pname version;
    rev-prefix = "v";
  };

  meta = {
    description = "Multi-GPU and multi-node collective communication primitives for NVIDIA GPUs";
    homepage = "https://developer.nvidia.com/nccl";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    # NCCL is not supported on Jetson, because it does not use NVLink or PCI-e for inter-GPU communication.
    # https://forums.developer.nvidia.com/t/can-jetson-orin-support-nccl/232845/9
    badPlatforms = lib.optionals flags.isJetsonBuild [ "aarch64-linux" ];
    maintainers = with lib.maintainers; [
      mdaiter
      orivej
    ];
    teams = [ lib.teams.cuda ];
  };
})
