{ stdenv
, lib
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
, pytest-subtests
, pytest-timeout
, pytestCheckHook
, pythonOlder
, pytz
, vine
, nixosTests
}:

buildPythonPackage rec {
  pname = "celery";
  version = "5.2.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0TmMrfMPV2Jms0Nw4o6IAwbsVfektjB1SbCunBVmNIE=";
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
    dnspython
    moto
    pymongo
    pytest-celery
    pytest-subtests
    pytest-timeout
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace requirements/default.txt \
      --replace "setuptools>=59.1.1,<59.7.0" "setuptools"
  '';

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

  passthru.tests = {
    inherit (nixosTests) sourcehut;
  };

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Distributed task queue";
    homepage = "https://github.com/celery/celery/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
