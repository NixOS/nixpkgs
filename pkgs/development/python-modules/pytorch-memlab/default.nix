{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  calmsize,
  pandas,
  torch,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytorch-memlab";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Stonesjtu";
    repo = "pytorch_memlab";
    tag = finalAttrs.version;
    hash = "sha256-46C/2RvzhbHt1IHPmPCrLsIk2D3POhzuADNaXqUe0F4=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  dependencies = [
    calmsize
    pandas
    torch
  ];

  pythonImportsCheck = [ "pytorch_memlab" ];

  # These tests require CUDA
  disabledTestPaths = [
    "test/test_courtesy.py"
    "test/test_line_profiler.py"
  ];

  meta = {
    description = "Simple and accurate CUDA memory management laboratory for pytorch";
    homepage = "https://github.com/Stonesjtu/pytorch_memlab";
    changelog = "https://github.com/Stonesjtu/pytorch_memlab/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
  };
})
