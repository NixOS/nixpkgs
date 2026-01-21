{
  _cuda,
  backendStdenv,
  cuda_cccl,
  cuda_cudart,
  cuda_nvcc,
  cudaAtLeast,
  cudaNamePrefix,
  fetchFromGitHub,
  flags,
  lib,
  python3,
  removeReferencesTo,
  which,
  # passthru.updateScript
  gitUpdater,
}:
let
  inherit (_cuda.lib) _mkMetaBadPlatforms;
  inherit (backendStdenv) hasJetsonCudaCapability requestedJetsonCudaCapabilities;
  inherit (lib)
    all
    flip
    getAttr
    getBin
    getInclude
    getLib
    licenses
    maintainers
    optionalString
    teams
    versionAtLeast
    versionOlder
    ;
in
backendStdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  # NOTE: Depends on the CUDA package set, so use cudaNamePrefix.
  name = "${cudaNamePrefix}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "nccl";

  # NOTE:
  #   Compilation errors resulting from newer versions of NCCL on older releases of CUDA seem to be caused (mostly)
  #   by differences in assumed version of CCCL: using a newer CCCL with an older release of CUDA can (sometimes) allow
  #   newer versions of NCCL than what we provide here.
  version =
    if cudaAtLeast "11.7" then
      "2.28.7-1"
    else if cudaAtLeast "11.6" then
      "2.26.6-1"
    else
      "2.25.1-1";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nccl";
    tag = "v${finalAttrs.version}";
    hash = getAttr finalAttrs.version {
      "2.28.7-1" = "sha256-NM19OiBBGmv3cGoVoRLKSh9Y59hiDoei9NIrRnTqWeA=";
      "2.26.6-1" = "sha256-vkWMGXCy+dIpYCecdafmOAGlnfRxIQ5Y2ZQuMjinraI=";
      "2.25.1-1" = "sha256-3snh0xdL9I5BYqdbqdl+noizJoI38mZRVOJChgEE1I8=";
    };
  };

  outputs = [
    "out"
    "dev"
    "static"
  ];

  nativeBuildInputs = [
    cuda_nvcc
    python3
    removeReferencesTo
    which
  ];

  buildInputs = [
    (getInclude cuda_nvcc)
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
  ''
  # 2.27.3-1 was the first to introuce CXXSTD
  + optionalString (versionOlder finalAttrs.version "2.27.3-1") ''
    nixLog "patching $PWD/makefiles/common.mk to remove NVIDIA's std hardcoding"
    substituteInPlace ./makefiles/common.mk \
      --replace-fail \
        '-std=c++11' \
        '$(CXXSTD)'
  '';

  # TODO: This would likely break under cross; need to delineate between build and host packages.
  makeFlags = [
    "CXXSTD=-std=c++17"
    "CUDA_HOME=${getBin cuda_nvcc}"
    "CUDA_INC=${getInclude cuda_cudart}/include"
    "CUDA_LIB=${getLib cuda_cudart}/lib"
    "NVCC_GENCODE=${flags.gencodeString}"
    "PREFIX=$(out)"
  ];

  enableParallelBuilding = true;

  postFixup = ''
    _overrideFirst outputStatic "static" "lib" "out"
    moveToOutput lib/libnccl_static.a "''${!outputStatic:?}"
  ''
  # Since CUDA 12.8, the cuda_nvcc path leaks in:
  # - libnccl.so's .nv_fatbin section
  # - libnccl_static.a
  # &devrt -L /nix/store/00000000000000000000000000000000-...nvcc-.../bin/...
  # This string makes cuda_nvcc a runtime dependency of nccl.
  # See https://github.com/NixOS/nixpkgs/pull/457803
  + ''
    remove-references-to -t "${lib.getBin cuda_nvcc}" \
      ''${!outputLib}/lib/libnccl.so.* \
      ''${!outputStatic}/lib/*.a
  '';

  # C.f. remove-references-to above. Ensure *all* references to cuda_nvcc are removed
  disallowedRequisites = [ (lib.getBin cuda_nvcc) ];

  passthru = {
    platformAssertions = [
      {
        message = "Pre-Thor Jetson devices (CUDA capabilities < 10.1) are not supported by NCCL";
        assertion =
          !hasJetsonCudaCapability || all (flip versionAtLeast "10.1") requestedJetsonCudaCapabilities;
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
    ];
    teams = [ teams.cuda ];
  };
})
