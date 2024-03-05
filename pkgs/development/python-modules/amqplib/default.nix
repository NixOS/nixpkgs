{ lib, buildPythonPackage, fetchPypi, python }:

buildPythonPackage rec {
  pname = "amqplib";
  version = "1.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "tgz";
    sha256 = "843d69b681a60afd21fbf50f310404ec67fcdf9d13dfcf6e9d41f3b456217e5b";
  };

  # testing assumes network connection
  doCheck = false;

  checkPhase = ''
    ${python.interpreter} tests/client_0_8/run_all.py
  '';

  meta = with lib; {
    homepage = "https://github.com/barryp/py-amqplib";
    description = "Python client for the Advanced Message Queuing Procotol (AMQP)";
    license = licenses.lgpl21;
  };
}
