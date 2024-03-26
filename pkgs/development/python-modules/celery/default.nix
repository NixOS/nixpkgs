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
, pytest-xdist
, pytestCheckHook
, python-dateutil
, pythonOlder
, tzdata
, vine
, nixosTests
}:

buildPythonPackage rec {
  pname = "celery";
  version = "5.3.6";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hwzHHXN8AgDDlykNcwNEzJkdE6BXU0NT0STJOAJnqrk=";
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
    pytest-xdist
    pytestCheckHook
  ];

  disabledTestPaths = [
    # test_eventlet touches network
    "t/unit/concurrency/test_eventlet.py"
    # test_multi tries to create directories under /var
    "t/unit/bin/test_multi.py"
    "t/unit/apps/test_multi.py"
    # requires moto<5
    "t/unit/backends/test_s3.py"
  ];

  disabledTests = [
    "msgpack"
    "test_check_privileges_no_fchown"
    # seems to only fail on higher core counts
    # AssertionError: assert 3 == 0
    "test_setup_security_disabled_serializers"
    # fails with pytest-xdist
    "test_itercapture_limit"
    "test_stamping_headers_in_options"
    "test_stamping_with_replace"
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
    mainProgram = "celery";
    homepage = "https://github.com/celery/celery/";
    changelog = "https://github.com/celery/celery/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
