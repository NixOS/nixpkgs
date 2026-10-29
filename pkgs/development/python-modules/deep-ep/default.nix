{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  torch,
  setuptools,

  # env
  cudaPackages,

  # buildInputs
  pybind11,
  rdma-core,

  config,
  cudaCapabilities ? torch.cudaCapabilities,
  cudaSupport ? config.cudaSupport,
}:
let
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

      DISABLE_SM90_FEATURES = if disableSm90Features then "1" else "0";

      CUDA_HOME = (lib.getBin cudaPackages.cuda_nvcc).outPath;
    }

    # nvshmem must be disabled (unsetting NVSHMEM_DIR) when supporting <9.0 capabilities
    # https://github.com/deepseek-ai/DeepEP/blob/v1.2.1/setup.py#L65
    // lib.optionalAttrs (!disableSm90Features) {
      NVSHMEM_DIR = (lib.getInclude cudaPackages.libnvshmem).outPath;
    }
  );

  buildInputs = [
    pybind11
    rdma-core
  ]
  ++ lib.optionals cudaSupport (
    with cudaPackages;
    [
      cuda_cccl # <nv/target>
      cuda_cudart # cuda_runtime.h
      libcublas # cublas_v2.h
      libcusolver # cusolverDn.h
      libcusparse # cusparse.h
    ]
    # On CUDA >=13.0, crt/host_config.h is shipped in cudaPackages.cuda_crt
    ++ lib.optionals cuda_crt.meta.available [
      cuda_crt # crt/host_config.h
    ]
  );

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
