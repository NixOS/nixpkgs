{ stdenv, buildPythonPackage, fetchPypi, pytestCheckHook, case, vine }:

buildPythonPackage rec {
  pname = "amqp";
  version = "2.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "70cdb10628468ff14e57ec2f751c7aa9e48e7e3651cfd62d431213c0c4e58f21";
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
