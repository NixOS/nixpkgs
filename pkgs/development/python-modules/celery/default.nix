{ stdenv
, lib
, backports-zoneinfo
, billiard
, boto3
, buildPythonPackage
, case
, click
, click-didyoumean
, click-plugins
, click-repl
, dnspython
, fetchPypi
, kombu
, moto
, pymongo
, pytest-celery
, pytest-click
, pytest-subtests
, pytest-timeout
, pytestCheckHook
, python-dateutil
, pythonOlder
, tzdata
, vine
, nixosTests
}:

buildPythonPackage rec {
  pname = "celery";
  version = "5.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Hqul7hTYyMC+2PYGPl4Q2r288jUDqGHPDhC3Ih2Zyw0=";
  };

  propagatedBuildInputs = [
    billiard
    click
    click-didyoumean
    click-plugins
    click-repl
    kombu
    python-dateutil
    tzdata
    vine
  ]
  ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
  ];

  nativeCheckInputs = [
    boto3
    case
    dnspython
    moto
    pymongo
    pytest-celery
    pytest-click
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
  ] ++ lib.optionals stdenv.isDarwin [
    # too many open files on hydra
    "test_cleanup"
    "test_with_autoscaler_file_descriptor_safety"
    "test_with_file_descriptor_safety"
  ];

  pythonImportsCheck = [
    "celery"
  ];

  passthru.tests = {
    inherit (nixosTests) sourcehut;
  };

  meta = with lib; {
    description = "Distributed task queue";
    homepage = "https://github.com/celery/celery/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
