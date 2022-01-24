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
  version = "5.0.9";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Hl9wdCTlRAeMoZbnKuahSIfOdOAr0Sa+VLfAPJcb7xg=";
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
