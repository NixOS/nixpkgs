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
<<<<<<< HEAD
  version = "2.0.8";
=======
  version = "2.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Lightning-AI";
    repo = "pytorch-lightning";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-Z/5d7aUO9UO7c9PoekxP8PMajKlh//hk/YIp+BJMcho=";
=======
    hash = "sha256-MSztKWjg/7J+4+sv4sqFlucaYuQlGoehtcUTiqNUlPA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
