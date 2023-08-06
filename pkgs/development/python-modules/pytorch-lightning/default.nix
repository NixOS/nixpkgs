{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, fsspec
, lightning-utilities
, numpy
, packaging
, pyyaml
, tensorboardx
, torch
, torchmetrics
, tqdm
, traitlets

# tests
, psutil
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytorch-lightning";
  version = "2.0.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Lightning-AI";
    repo = "pytorch-lightning";
    rev = "refs/tags/${version}";
    hash = "sha256-/RfHryuIFhLn9SCg6YVn0Ley8ajcIlsDtuKNuhUFm8M=";
  };

  preConfigure = ''
    export PACKAGE_NAME=pytorch
 '';

  propagatedBuildInputs = [
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
  ]
  ++ fsspec.optional-dependencies.http;

  nativeCheckInputs = [
    psutil
    pytestCheckHook
  ];

  # Some packages are not in NixPkgs; other tests try to build distributed
  # models, which doesn't work in the sandbox.
  doCheck = false;

  pythonImportsCheck = [
    "pytorch_lightning"
  ];

  meta = with lib; {
    description = "Lightweight PyTorch wrapper for machine learning researchers";
    homepage = "https://pytorch-lightning.readthedocs.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ tbenst ];
  };
}
