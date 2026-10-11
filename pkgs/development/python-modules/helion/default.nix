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
  numpy,
  psutil,
  rich,
  scikit-learn,
  typing-extensions,
  torch,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  helion,
}:

buildPythonPackage (finalAttrs: {
  pname = "helion";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "helion";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3Iam+1FUg9I9kKmkQBZp9/FTZpEjf4Ba+cKRo5eLEzw=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    filecheck
    numpy
    psutil
    rich
    scikit-learn
    typing-extensions

    # torch is not listed as a dependency, but is actually required at import time
    # https://github.com/pytorch/helion/blob/v1.0.0/helion/_compat.py#L13
    torch
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
  passthru.gpuCheck = helion.overridePythonAttrs {
    doCheck = true;
    requiredSystemFeatures = [ "cuda" ];
  };

  meta = {
    description = "Python-embedded DSL that makes it easy to write fast, scalable ML kernels with minimal boilerplate";
    homepage = "https://github.com/pytorch/helion";
    changelog = "https://github.com/pytorch/helion/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    # This package explicitly requires CUDA-enabled pytorch
    broken = !config.cudaSupport;
  };
})
