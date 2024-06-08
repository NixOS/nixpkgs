{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fsspec,
  lightning-utilities,
  numpy,
  packaging,
  pyyaml,
  setuptools,
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
  version = "2.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Lightning-AI";
    repo = "pytorch-lightning";
    rev = "refs/tags/${version}";
    hash = "sha256-2O6Gr9BdjI/WTU0+KTfOQG31xzHyBeqxGv97f3WxUMs=";
  };

  preConfigure = ''
    export PACKAGE_NAME=pytorch
  '';

  build-system = [ setuptools ];

  dependencies = [
    fsspec
    numpy
    packaging
    pyyaml
    tensorboardx
    torch
    lightning-utilities
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

  meta = with lib; {
    description = "Lightweight PyTorch wrapper for machine learning researchers";
    homepage = "https://github.com/Lightning-AI/pytorch-lightning";
    changelog = "https://github.com/Lightning-AI/pytorch-lightning/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ tbenst ];
  };
}
