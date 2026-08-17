{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  ninja,
  setuptools,
  torch,

  # tests
  pytestCheckHook,
}:
let
  inherit (torch) cudaPackages cudaSupport cudaCapabilities;
in
buildPythonPackage.override { inherit (torch) stdenv; } (finalAttrs: {
  pname = "pyg-lib";
  version = "0.7.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pyg-team";
    repo = "pyg-lib";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-czHSOIocmoup502kLS8v+aeu6fVPPhqFh3hbGcFvNEQ=";
  };

  build-system = [
    cmake
    ninja
    setuptools
    torch
  ];
  dontUseCmakeConfigure = true;

  nativeBuildInputs = lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];

  env = lib.optionalAttrs cudaSupport {
    TORCH_CUDA_ARCH_LIST = "${lib.concatStringsSep ";" cudaCapabilities}";
  };

  buildInputs = [
    torch.cxxdev
    torch
  ];

  pythonImportsCheck = [ "pyg_lib" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    rm -rf pyg_lib
  '';

  disabledTests =
    lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
      # aarch64-linux fails cpuinfo test, because /sys/devices/system/cpu/ does not exist in the sandbox:
      # RuntimeError: Failed to initialize cpuinfo!
      "test_scatter_mean_forward_dtypes"
      "test_scatter_sum_forward_dtypes"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Trace/BPT trap: 5
      "test_hetero_neighbor_sampler_temporal_sample"
    ];

  meta = {
    description = "Low-Level Graph Neural Network Operators for PyG";
    homepage = "https://github.com/pyg-team/pyg-lib";
    changelog = "https://github.com/pyg-team/pyg-lib/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      bsd3
    ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
