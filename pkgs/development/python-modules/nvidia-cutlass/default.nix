{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  cuda-bindings,
  cuda-pathfinder,
  networkx,
  numpy,
  pydot,
  scipy,
  treelib,

  # tests
  pytestCheckHook,
  torch,
}:

buildPythonPackage (finalAttrs: {
  pname = "nvidia-cutlass";
  version = "4.2.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutlass";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XicHeV9ni9bSOWcUJM8HrCuz61mVK1EdZ9uxNvgWmvk=";
  };

  build-system = [
    setuptools
  ];

  pythonRemoveDeps = [
    # Replaced with the cuda-python sub-packages we actually need
    "cuda-python"
  ];
  dependencies = [
    cuda-bindings
    cuda-pathfinder
    networkx
    numpy
    pydot
    scipy
    treelib
  ];

  pythonImportsCheck = [
    "cutlass_cppgen"
    "cutlass_library"
    "pycute"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    torch
  ];

  enabledTestPaths = [
    "test"
  ];

  meta = {
    description = "Python bindings for NVIDIA's CUTLASS library";
    homepage = "https://github.com/NVIDIA/cutlass";
    changelog = "https://github.com/NVIDIA/cutlass/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
