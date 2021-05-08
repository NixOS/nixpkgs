{ lib, buildPythonPackage, fetchPypi
, billiard, click, click-didyoumean, click-plugins, click-repl, kombu, pytz, vine
, boto3, case, moto, pytest, pytest-celery, pytest-subtests, pytest-timeout
}:

buildPythonPackage rec {
  pname = "celery";
  version = "5.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f4efebe6f8629b0da2b8e529424de376494f5b7a743c321c8a2ddc2b1414921c";
  };

  postPatch = ''
    substituteInPlace requirements/test.txt \
      --replace "moto==1.3.7" moto
  '';

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
