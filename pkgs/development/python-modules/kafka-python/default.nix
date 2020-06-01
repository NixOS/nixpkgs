{ stdenv, buildPythonPackage, fetchPypi, pytest, six, mock }:

buildPythonPackage rec {
  version = "2.0.1";
  pname = "kafka-python";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1y7ny81rihnhc8lj921d76ir4kf4aj5iy35szgim8zccxhnx96p5";
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
    homepage = "https://github.com/dpkp/kafka-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
