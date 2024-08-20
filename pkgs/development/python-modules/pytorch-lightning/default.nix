{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  fsspec,
  lightning-utilities,
  numpy,
  packaging,
  pyyaml,
  tensorboardx,
  torch,
  torchmetrics,
  tqdm,
  traitlets,

  # tests
  psutil,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytorch-lightning";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Lightning-AI";
    repo = "pytorch-lightning";
    rev = "refs/tags/${version}";
    hash = "sha256-FngD3nYTGVEjS1VrXAVps2/B8VlS7BZMDAsmIDtAyW0=";
  };

  preConfigure = ''
    export PACKAGE_NAME=pytorch
  '';

  build-system = [ setuptools ];

  dependencies = [
    fsspec
    lightning-utilities
    numpy
    packaging
    pyyaml
    tensorboardx
    torch
    torchmetrics
    tqdm
    traitlets
  ] ++ fsspec.optional-dependencies.http;

  nativeCheckInputs = [
    psutil
    pytestCheckHook
  ];

  # Some packages are not in NixPkgs; other tests try to build distributed
  # models, which doesn't work in the sandbox.
  doCheck = false;

  pythonImportsCheck = [ "pytorch_lightning" ];

  meta = {
    description = "Lightweight PyTorch wrapper for machine learning researchers";
    homepage = "https://github.com/Lightning-AI/pytorch-lightning";
    changelog = "https://github.com/Lightning-AI/pytorch-lightning/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tbenst ];
  };
}
