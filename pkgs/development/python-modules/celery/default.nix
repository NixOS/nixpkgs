{ lib
, billiard
, boto3
, buildPythonPackage
, case
, click
, click-didyoumean
, click-plugins
, click-repl
, fetchPypi
, kombu
, moto
, pymongo
, pytest-celery
, pytest-subtests
, pytest-timeout
, pytestCheckHook
, pythonOlder
, pytz
, vine
}:

buildPythonPackage rec {
  pname = "celery";
  version = "5.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tBpZC0nK+OZJilfbYo5YDV+Nxv69oPQt5deDrtW3+Ag=";
  };

  propagatedBuildInputs = [
    billiard
    click
    click-didyoumean
    click-plugins
    click-repl
    kombu
    pytz
    vine
  ];

  checkInputs = [
    boto3
    case
    moto
    pymongo
    pytest-celery
    pytest-subtests
    pytest-timeout
    pytestCheckHook
  ];

  disabledTestPaths = [
    # test_eventlet touches network
    "t/unit/concurrency/test_eventlet.py"
    # test_multi tries to create directories under /var
    "t/unit/bin/test_multi.py"
    "t/unit/apps/test_multi.py"
  ];

  disabledTests = [
    "msgpack"
    "test_check_privileges_no_fchown"
  ];

  pythonImportsCheck = [
    "celery"
  ];

  meta = with lib; {
    description = "Distributed task queue";
    homepage = "https://github.com/celery/celery/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
