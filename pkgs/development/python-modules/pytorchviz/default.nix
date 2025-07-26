{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  distutils,
  fsspec,
  graphviz,
  torch,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytorchviz";
  version = "0.0.2-unstable-2024-12-30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "szagoruyko";
    repo = "pytorchviz";
    # No tags in the upstream GitHub repo
    rev = "5cf04c13e601366f6b9cf5939b5af5144d55b887";
    hash = "sha256-La1X8Y64n/vNGDUEsw1iZ5Mb6/w3WayeWxa62QxLyHA=";
  };

  dependencies = [
    graphviz
    torch
  ];

  nativeCheckInputs = [
    unittestCheckHook
    distutils
    fsspec
  ];

  unittestFlagsArray = [ "test/" ];

  pythonImportsCheck = [ "torchviz" ];

  meta = {
    description = "Small package to create visualizations of PyTorch execution graphs";
    homepage = "https://github.com/szagoruyko/pytorchviz";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
  };
}
