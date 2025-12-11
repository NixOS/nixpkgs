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

buildPythonPackage rec {
  pname = "pytorch-memlab";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Stonesjtu";
    repo = "pytorch_memlab";
    tag = version;
    hash = "sha256-wNgbipvi3vYr9Ka9hA7I+C4y8Nf6AiZXUoXX+qKtZ+I=";
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
    changelog = "https://github.com/Stonesjtu/pytorch_memlab/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
  };
}
