{
  lib,
  config,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  filecheck,
  psutil,
  rich,
  torch,
  tqdm,
  triton,
  typing-extensions,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  helion,
}:

buildPythonPackage rec {
  pname = "helion";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "helion";
    tag = "v${version}";
    hash = "sha256-JuuVPz8FPKtaGxbJM4omUzIjY9chtGZFGXwEMX34/Y0=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    filecheck
    psutil
    rich
    torch
    tqdm
    triton
    typing-extensions
  ];

  pythonImportsCheck = [ "helion" ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # Flaky: AssertionError: Tensor-likes are not close!
    # Mismatched elements: 3 / 65536 (0.0%)
    "test_squeeze_and_excitation_net_bwd_dx"
  ];

  # Tests require GPU access
  doCheck = false;
  passthru.gpuChecks = {
    pytest = helion.overridePythonAttrs {
      doCheck = true;
      requiredSystemFeatures = [ "cuda" ];
    };
  };

  meta = {
    description = "Python-embedded DSL that makes it easy to write fast, scalable ML kernels with minimal boilerplate";
    homepage = "https://github.com/pytorch/helion";
    changelog = "https://github.com/pytorch/helion/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    # This package explicitly requires CUDA-enabled pytorch
    broken = !config.cudaSupport;
  };
}
