{ stdenv, buildPythonPackage, fetchPypi, pytest, six, mock }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  version = "1.4.3";
  pname = "kafka-python";

  src = fetchPypi {
    inherit pname version;
    sha256 = "078acdcd1fc6eddacc46d437c664998b4cf7613b7e79ced66a460965f2648f88";
  };

  checkInputs = [ pytest six mock ];

  checkPhase = ''
    py.test
  '';

  # Upstream uses tox but we don't on Nix. Running tests manually produces however
  #     from . import unittest
  # E   ImportError: cannot import name 'unittest'
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Pure Python client for Apache Kafka";
    homepage = https://github.com/dpkp/kafka-python;
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
