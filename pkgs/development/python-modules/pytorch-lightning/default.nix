{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, future
, fsspec
, packaging
, pytestCheckHook
, pytorch
, pyyaml
, tensorboard
, torchmetrics
, tqdm }:

buildPythonPackage rec {
  pname = "pytorch-lightning";
  version = "1.6.3";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "PyTorchLightning";
    repo = pname;
    rev = version;
    hash = "sha256-MEUFrj84y5lQfwbC9s9fJNOKo+Djeh+E/eDc8KeX7V4=";
  };

  propagatedBuildInputs = [
    packaging
    future
    fsspec
    pytorch
    pyyaml
    tensorboard
    torchmetrics
    tqdm
  ];

  checkInputs = [ pytestCheckHook ];
  # Some packages are not in NixPkgs; other tests try to build distributed
  # models, which doesn't work in the sandbox.
  doCheck = false;

  pythonImportsCheck = [ "pytorch_lightning" ];

  meta = with lib; {
    description = "Lightweight PyTorch wrapper for machine learning researchers";
    homepage = "https://pytorch-lightning.readthedocs.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ tbenst ];
  };
}
