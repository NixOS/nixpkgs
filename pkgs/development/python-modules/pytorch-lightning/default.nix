{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, future
, pytestCheckHook
, pytorch
, pyyaml
, tensorflow-tensorboard
, tqdm }:

buildPythonPackage rec {
  pname = "pytorch-lightning";
  version = "0.8.5";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "PyTorchLightning";
    repo = pname;
    rev = version;
    sha256 = "12zhq4pnfcwbgcx7cs99c751gp3w0ysaf5ykv2lv8f4i360w3r5a";
  };

  requiredPythonModules = [
    future
    pytorch
    pyyaml
    tensorflow-tensorboard
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
