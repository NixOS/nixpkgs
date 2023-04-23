{ lib, buildPythonPackage, fetchPypi, pytest, six, mock }:

buildPythonPackage rec {
  version = "2.0.2";
  pname = "kafka-python";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04dfe7fea2b63726cd6f3e79a2d86e709d608d74406638c5da33a01d45a9d7e3";
  };

  nativeCheckInputs = [ pytest six mock ];

  checkPhase = ''
    py.test
  '';

  # Upstream uses tox but we don't on Nix. Running tests manually produces however
  #     from . import unittest
  # E   ImportError: cannot import name 'unittest'
  doCheck = false;

  meta = with lib; {
    description = "Pure Python client for Apache Kafka";
    homepage = "https://github.com/dpkp/kafka-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
