{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  six,
  mock,
}:

buildPythonPackage rec {
  version = "2.0.2";
  format = "setuptools";
  pname = "kafka-python";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BN/n/qK2NybNbz55othucJ1gjXRAZjjF2jOgHUWp1+M=";
  };

  nativeCheckInputs = [
    pytest
    six
    mock
  ];

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
