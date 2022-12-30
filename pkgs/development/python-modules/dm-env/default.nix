{ lib
, fetchPypi
, buildPythonPackage
, dm-tree
, numpy
, absl-py
, nose }:

buildPythonPackage rec {
  pname = "dm-env";
  version = "1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-pDbrHGVMOeDJhqUWzuIYvqcUC1EPzv9j+X60/P89k94=";
  };

  buildInputs = [
    absl-py
    dm-tree
    numpy
  ];

  checkInputs = [
    nose
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
