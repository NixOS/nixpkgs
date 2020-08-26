{ stdenv, buildPythonPackage, fetchPypi, pytestCheckHook, case, vine }:

buildPythonPackage rec {
  pname = "amqp";
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "24dbaff8ce4f30566bb88976b398e8c4e77637171af3af6f1b9650f48890e60b";
  };

  propagatedBuildInputs = [ vine ];

  checkInputs = [ pytestCheckHook case ];
  disabledTests = [
    "test_rmq.py" # requires network access
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/celery/py-amqp";
    description = "Python client for the Advanced Message Queuing Procotol (AMQP). This is a fork of amqplib which is maintained by the Celery project";
    license = licenses.lgpl21;
  };
}
