{ stdenv, buildPythonPackage, fetchPypi, pytest, six, mock }:

buildPythonPackage rec {
  version = "1.4.6";
  pname = "kafka-python";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08f83d8e0af2e64d25f94314d4bef6785b34e3b0df0effe9eebf76b98de66eeb";
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
