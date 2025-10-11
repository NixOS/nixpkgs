# NOTE: Though NCCL is called within the cudaPackages package set, we avoid passing in
# the names of dependencies from that package set directly to avoid evaluation errors
# in the case redistributable packages are not available.
{
  _cuda,
  backendStdenv,
  cuda_cccl,
  cuda_cudart,
  cuda_nvcc,
  cudaNamePrefix,
  fetchFromGitHub,
  flags,
  lib,
  python3,
  which,
  # passthru.updateScript
  gitUpdater,
}:
let
  inherit (_cuda.lib) _mkMetaBadPlatforms;
  inherit (backendStdenv) hasJetsonCudaCapability requestedJetsonCudaCapabilities;
  inherit (lib) licenses maintainers teams;
  inherit (lib.attrsets)
    getBin
    getLib
    getOutput
    ;
in
backendStdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  # NOTE: Depends on the CUDA package set, so use cudaNamePrefix.
  name = "${cudaNamePrefix}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "nccl";
  version = "2.27.6-1";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nccl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/BiLSZaBbVIqOfd8nQlgUJub0YR3SR4B93x2vZpkeiU=";
  };

  outputs = [
    "out"
    "dev"
    "static"
  ];

  nativeBuildInputs = [
    cuda_nvcc
    python3
    which
  ];

  buildInputs = [
    (getOutput "include" cuda_nvcc)
    cuda_cccl
    cuda_cudart
  ];

  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-unused-function" ];

  postPatch = ''
    patchShebangs ./src/device/generate.py
    patchShebangs ./src/device/symmetric/generate.py

    nixLog "patching $PWD/makefiles/common.mk to remove NVIDIA's ccbin declaration"
    substituteInPlace ./makefiles/common.mk \
      --replace-fail \
        '-ccbin $(CXX)' \
        ""
  '';

  # TODO: This would likely break under cross; need to delineate between build and host packages.
  makeFlags = [
    "CUDA_HOME=${getBin cuda_nvcc}"
    "CUDA_INC=${getOutput "include" cuda_cudart}/include"
    "CUDA_LIB=${getLib cuda_cudart}/lib"
    "NVCC_GENCODE=${flags.gencodeString}"
    "PREFIX=$(out)"
  ];

  enableParallelBuilding = true;

  postFixup = ''
    moveToOutput lib/libnccl_static.a "$static"
  '';

  passthru = {
    platformAssertions = [
      {
        message = "Pre-Thor Jetson devices (CUDA capabilities < 10.1) are not supported by NCCL";
        assertion =
          !hasJetsonCudaCapability
          || lib.all (lib.flip lib.versionAtLeast "10.1") requestedJetsonCudaCapabilities;
      }
    ];

    updateScript = gitUpdater {
      inherit (finalAttrs) pname version;
      rev-prefix = "v";
    };
  };

  meta = {
    description = "Multi-GPU and multi-node collective communication primitives for NVIDIA GPUs";
    homepage = "https://developer.nvidia.com/nccl";
    license = licenses.bsd3;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    # NCCL is not supported on Pre-Thor Jetsons, because it does not use NVLink or PCI-e for inter-GPU communication.
    # https://forums.developer.nvidia.com/t/can-jetson-orin-support-nccl/232845/9
    badPlatforms = _mkMetaBadPlatforms finalAttrs;
    maintainers = with maintainers; [
      mdaiter
      orivej
    ];
    teams = [ teams.cuda ];
  };
})
