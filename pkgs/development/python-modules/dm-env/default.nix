{ lib
, fetchPypi
, buildPythonPackage
, dm-tree
, numpy
, absl-py
, nose }:

buildPythonPackage rec {
  pname = "dm-env";
  version = "1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Pv2ZsGUlY1mVB8QV1ItRiWyIvi8BwrYlCvi6tRVx41M=";
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
