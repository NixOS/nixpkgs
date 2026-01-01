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
<<<<<<< HEAD
  version = "2.6.0";
=======
  version = "2.5.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Lightning-AI";
    repo = "pytorch-lightning";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-zmFA9/tz0C06LmQ37wHeoR1kBHKdoz/D1cKWMoeWHzs=";
=======
    hash = "sha256-ojmE0d6Wy4UqQu4kBBE2qtQ4AYqplHOB7wJ7hEte664=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
    torch
    torchmetrics
    tqdm
    traitlets
  ]
  ++ fsspec.optional-dependencies.http;

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
