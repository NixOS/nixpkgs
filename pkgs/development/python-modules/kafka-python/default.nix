{ stdenv, buildPythonPackage, fetchPypi, pytest, six, mock }:

buildPythonPackage rec {
  version = "1.4.4";
  pname = "kafka-python";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p9sr9vl96xz8qrgdrjiql9qkch2qx29pkq7igk28clgc6zbn510";
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
