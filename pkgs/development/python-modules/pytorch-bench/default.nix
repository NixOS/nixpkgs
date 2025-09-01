{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  colorama,
  matplotlib,
  numpy,
  pynvml,
  torch,
  torchprofile,
}:

buildPythonPackage {
  pname = "pytorch-bench";
  version = "unstable-2024-07-18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MaximeGloesener";
    repo = "torch-benchmark";
    rev = "405a3fc2d147b43b4c1f7edb7aca0a60ba343ac5";
    hash = "sha256-KU3dAf97A6lkMNTKRay23BMFQfn1ReAFNaJ0kG2RfnA=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    colorama
    matplotlib
    numpy
    pynvml
    torch
    torchprofile
  ];

  pythonImportsCheck = [
    "pytorch_bench"
  ];

  meta = {
    description = "Benchmarking tool for torch";
    homepage = "https://github.com/MaximeGloesener/torch-benchmark";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
