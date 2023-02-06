{ lib
, buildPythonPackage
, fetchPypi
, datasets
, evaluate
, numpy
, packaging
, psutil
, pyyaml
, pytestCheckHook
, torch
}:

buildPythonPackage rec {
  pname = "accelerate";
  version = "0.16.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0T4w8+bev7Rsrae5Ma+FVgYZtqaoOdDK/uq27XxqSY0=";
  };

  propagatedBuildInputs = [
    numpy
    packaging
    psutil
    pyyaml
    torch
  ];

  nativeCheckInputs = [
    pytestCheckHook
    datasets
    evaluate
  ];

  pythonImportsCheck = [
    "accelerate"
  ];

  meta = with lib; {
    description = "A simple way to train and use PyTorch models with multi-GPU, TPU, mixed-precision";
    homepage = "https://github.com/huggingface/accelerate";
    license = licenses.asl20;
    maintainers = with maintainers; [ YodaEmbedding ];
  };
}
