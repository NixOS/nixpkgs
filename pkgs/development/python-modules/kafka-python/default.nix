{ stdenv, buildPythonPackage, fetchPypi, pytest, six, mock }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  version = "1.3.5";
  pname = "kafka-python";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19m9fdckxqngrgh0www7g8rgi7z0kq13wkhcqy1r8aa4sxad0f5j";
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
