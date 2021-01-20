{ lib, stdenv, buildPythonPackage, fetchPypi, pytestCheckHook, case, vine }:

buildPythonPackage rec {
  pname = "amqp";
  version = "5.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fcd5b3baeeb7fc19b3486ff6d10543099d40ae1f5c9196eae695d1cde1b2f784";
  };

  propagatedBuildInputs = [ vine ];

  checkInputs = [ pytestCheckHook case ];
  disabledTests = [
    "test_rmq.py" # requires network access
  ];

  meta = with lib; {
    homepage = "https://github.com/celery/py-amqp";
    description = "Python client for the Advanced Message Queuing Procotol (AMQP). This is a fork of amqplib which is maintained by the Celery project";
    license = licenses.lgpl21;
  };
}
