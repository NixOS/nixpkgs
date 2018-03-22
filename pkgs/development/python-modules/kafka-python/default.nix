{ stdenv, buildPythonPackage, fetchPypi, pytest, six, mock }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  version = "1.4.1";
  pname = "kafka-python";

  src = fetchPypi {
    inherit pname version;
    sha256 = "596e9b4e302a0dc04d35be159cf23d31c4cba73a218e16fc8cd1be0ad57f8c22";
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
