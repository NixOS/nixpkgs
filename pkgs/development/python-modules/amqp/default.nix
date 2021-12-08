{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook, case, vine }:

buildPythonPackage rec {
  pname = "amqp";
  version = "5.0.6";

  src = fetchFromGitHub {
     owner = "celery";
     repo = "py-amqp";
     rev = "v5.0.6";
     sha256 = "1jp192bp8wjcq0z7y41hlxmh3iqm55s94f3k4dk7xhghp99yjifd";
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
