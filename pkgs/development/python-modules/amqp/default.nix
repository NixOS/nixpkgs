{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, case, vine }:

buildPythonPackage rec {
  pname = "amqp";
  version = "5.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1733ebf713050504fd9d2ebc661f1fc95b3588f99ee87d2e39c84c27bfd815dc";
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
