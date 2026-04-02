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
  scikit-learn,
  torch,
  tqdm,
  triton,
  typing-extensions,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  helion,
}:

buildPythonPackage (finalAttrs: {
  pname = "helion";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "helion";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MR8fo6MhMSAXlBsx//ODIprXPXFhMy6K5Mno9BnZGHc=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    filecheck
    psutil
    rich
    scikit-learn
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
    changelog = "https://github.com/pytorch/helion/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    # This package explicitly requires CUDA-enabled pytorch
    broken = !config.cudaSupport;
  };
})
