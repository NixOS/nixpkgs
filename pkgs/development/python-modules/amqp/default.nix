{ lib
, buildPythonPackage
, case
, fetchPypi
, pytestCheckHook
, pytest-rerunfailures
, pythonOlder
, vine
}:

buildPythonPackage rec {
  pname = "amqp";
  version = "5.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LBsT/swIk+lGxly9XzZCeGHP+k6iIB2Pb8oi4qNzteI=";
  };

  propagatedBuildInputs = [
    vine
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    case
    pytestCheckHook
    pytest-rerunfailures
  ];

  disabledTests = [
    # Requires network access
    "test_rmq.py"
  ];

  pythonImportsCheck = [
    "amqp"
  ];

  meta = with lib; {
    description = "Python client for the Advanced Message Queuing Procotol (AMQP). This is a fork of amqplib which is maintained by the Celery project";
    homepage = "https://github.com/celery/py-amqp";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
