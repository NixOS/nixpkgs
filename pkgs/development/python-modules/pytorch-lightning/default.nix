{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pytestCheckHook
, lightning-lite
, lightning-utilities
, torchmetrics
}:

buildPythonPackage rec {
  pname = "pytorch-lightning";
  version = "1.8.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3v+bx5eOzryPReiBre9l3I2fRVTojDsGT4BYfzKrFY0=";
  };

  propagatedBuildInputs = [
    lightning-lite
    lightning-utilities
    torchmetrics
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
