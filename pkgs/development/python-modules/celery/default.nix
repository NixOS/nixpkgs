{ lib, buildPythonPackage, fetchPypi
, billiard, click, click-didyoumean, click-plugins, click-repl, kombu, pytz, vine
, boto3, case, moto, pytest, pytest-celery, pytest-subtests, pytest-timeout
}:

buildPythonPackage rec {
  pname = "celery";
  version = "5.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tBpZC0nK+OZJilfbYo5YDV+Nxv69oPQt5deDrtW3+Ag=";
  };

  propagatedBuildInputs = [ billiard click click-didyoumean click-plugins click-repl kombu pytz vine ];

  checkInputs = [ boto3 case moto pytest pytest-celery pytest-subtests pytest-timeout ];

  # ignore test that's incompatible with pytest5
  # test_eventlet touches network
  # test_mongodb requires pymongo
  # test_multi tries to create directories under /var
  checkPhase = ''
    pytest -k 'not restore_current_app_fallback and not msgpack and not on_apply and not pytest' \
      --ignore=t/unit/contrib/test_pytest.py \
      --ignore=t/unit/concurrency/test_eventlet.py \
      --ignore=t/unit/bin/test_multi.py \
      --ignore=t/unit/apps/test_multi.py \
      --ignore=t/unit/backends/test_mongodb.py
  '';

  meta = with lib; {
    homepage = "https://github.com/celery/celery/";
    description = "Distributed task queue";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
