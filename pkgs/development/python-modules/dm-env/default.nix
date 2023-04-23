{ lib
, fetchPypi
, buildPythonPackage
, dm-tree
, numpy
, absl-py
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dm-env";
  version = "1.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pDbrHGVMOeDJhqUWzuIYvqcUC1EPzv9j+X60/P89k94=";
  };

  buildInputs = [
    absl-py
    dm-tree
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dm_env"
  ];

  meta = with lib; {
    description = "Pure Python client for Apache Kafka";
    homepage = "https://github.com/dpkp/kafka-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ onny ];
  };
}
