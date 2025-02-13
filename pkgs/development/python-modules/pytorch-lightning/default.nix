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
  version = "2.5.0.post0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Lightning-AI";
    repo = "pytorch-lightning";
    tag = version;
    hash = "sha256-TkwDncyfv1VoV/IErUgF4p0Or5PJbwKoABqo1xXGLVg=";
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
    changelog = "https://github.com/Lightning-AI/pytorch-lightning/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tbenst ];
  };
}
