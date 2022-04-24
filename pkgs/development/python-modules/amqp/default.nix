{ lib
, buildPythonPackage
, case
, fetchPypi
, pytestCheckHook
, pythonOlder
, vine
}:

buildPythonPackage rec {
  pname = "amqp";
  version = "5.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RGs+io68LOr9Qk/8qrHDU4MNSBYSVleO16ZUSOYB6+0=";
  };

  propagatedBuildInputs = [
    vine
  ];

  checkInputs = [
    case
    pytestCheckHook
  ];

  disabledTests = [
    # Requires network access
    "test_rmq.py"
  ];

  pythonImportsCheck = [
    "amqp"
  ];

  meta = with lib; {
    homepage = "https://github.com/celery/py-amqp";
    description = "Python client for the Advanced Message Queuing Procotol (AMQP). This is a fork of amqplib which is maintained by the Celery project";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
