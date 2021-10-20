{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, case, vine }:

buildPythonPackage rec {
  pname = "amqp";
  version = "5.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03e16e94f2b34c31f8bf1206d8ddd3ccaa4c315f7f6a1879b7b1210d229568c2";
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
