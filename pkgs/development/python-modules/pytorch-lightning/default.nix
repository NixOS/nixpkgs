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
  version = "1.5.8";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "PyTorchLightning";
    repo = pname;
    rev = version;
    sha256 = "161mz66l11z4350q93fmmq3x0jzbp5761lf4fx3yvz17qzp7ygkn";
  };

  propagatedBuildInputs = [
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
