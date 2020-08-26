{ lib, buildPythonPackage, fetchPypi, libredirect
, case, pytest, boto3, moto, kombu, billiard, pytz, future, vine
}:

buildPythonPackage rec {
  pname = "celery";
  version = "4.4.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ni5c3qgbhb7871b3i55wc306m3g2n0qxp92g5gszdxiicjf8xzx";
  };

  postPatch = ''
    substituteInPlace requirements/default.txt \
      --replace "kombu>=4.6.10,<4.7" "kombu"
    substituteInPlace requirements/test.txt \
      --replace "moto==1.3.7" moto \
      --replace "pytest>=4.3.1,<4.4.0" pytest
  '';

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

  checkInputs = [ case pytest boto3 moto ];
  propagatedBuildInputs = [ kombu billiard pytz future vine ];

  meta = with lib; {
    homepage = "https://github.com/celery/celery/";
    description = "Distributed task queue";
    license = licenses.bsd3;
  };
}
