{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  torch,
  setuptools,

  # env
  symlinkJoin,
  cudaPackages,

  # buildInputs
  pybind11,
  rdma-core,

  config,
  cudaCapabilities ? torch.cudaCapabilities,
  cudaSupport ? config.cudaSupport,
}:
let
  inherit (lib)
    getBin
    getInclude
    ;

  minSupportedCudaCapability = "8.0"; # build fails with 7.5

  minCudaCapability = builtins.head (
    builtins.sort (a: b: builtins.compareVersions a b < 0) cudaCapabilities
  );

  cudaCapabilities' =
    if lib.versionOlder minCudaCapability minSupportedCudaCapability then
      throw ''
        CUDA capability "${minCudaCapability}" from `cudaCapabilities` is incompatible with DeepEP.
        Only CUDA capabilities must be "${minSupportedCudaCapability}" or newer.
        Build `python3Packages.deep-ep` with a compatible `cudaCapabilities` list.
      ''
    else
      cudaCapabilities;

  disableSm90Features = lib.versionOlder minCudaCapability "9.0";
in
buildPythonPackage.override { inherit (torch) stdenv; } (finalAttrs: {
  pname = "deep-ep";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deepseek-ai";
    repo = "DeepEP";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xURR3uBAwKjDTNEG9p/vRRhH4Ldiz/u6kD/a+DPn5/Q=";
  };

  build-system = [
    setuptools
    torch
  ];

  env = lib.optionalAttrs cudaSupport (
    {
      TORCH_CUDA_ARCH_LIST = "${lib.concatStringsSep " " cudaCapabilities'}";

      DISABLE_SM90_FEATURES =
        if disableSm90Features then
          lib.warn ''
            python3Packages.deepep: Disabling SM90 features as the provided `cudaCapabilities` list include '${minCudaCapability}'
          '' "1"
        else
          "0";

      CUDA_HOME = symlinkJoin {
        name = "cuda-redist";
        paths = with cudaPackages; [
          (getBin cuda_nvcc)

          (getInclude cuda_cccl) # <nv/target>
          (getInclude cuda_cudart) # cuda_runtime.h
          (getInclude libcublas) # cublas_v2.h
          (getInclude libcusolver) # cusolverDn.h
          (getInclude libcusparse) # cusparse.h
        ];
      };
    }

    # nvshmem must be disabled (unsetting NVSHMEM_DIR) when supporting <9.0 capabilities
    # https://github.com/deepseek-ai/DeepEP/blob/v1.2.1/setup.py#L65
    // lib.optionalAttrs (!disableSm90Features) {
      NVSHMEM_DIR = (getInclude cudaPackages.libnvshmem).outPath;
    }
  );

  buildInputs = [
    pybind11
    rdma-core
  ];

  pythonImportsCheck = [ "deep_ep" ];

  # Tests check internode communications which is not possible in the sandbox
  doCheck = false;

  meta = {
    description = "Efficient expert-parallel communication library";
    homepage = "https://github.com/deepseek-ai/DeepEP";
    changelog = "https://github.com/deepseek-ai/DeepEP/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    broken = !cudaSupport;
  };
})
