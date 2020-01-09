{ lib, buildPythonPackage, fetchPypi, libredirect
, case, pytest, boto3, moto, kombu, billiard, pytz, anyjson, amqp, eventlet
}:

buildPythonPackage rec {
  pname = "celery";
  version = "4.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d3363bb5df72d74420986a435449f3c3979285941dff57d5d97ecba352a0e3e2";
  };

  postPatch = ''
    substituteInPlace requirements/test.txt \
      --replace "moto==1.3.7" moto \
      --replace "pytest>=4.3.1,<4.4.0" pytest
  '';

  # ignore test that's incompatible with pytest5
  # test_eventlet touches network
  # test_mongodb requires pymongo
  checkPhase = ''
    pytest -k 'not restore_current_app_fallback and not msgpack' \
      --ignore=t/unit/concurrency/test_eventlet.py \
      --ignore=t/unit/backends/test_mongodb.py
  '';

  checkInputs = [ case pytest boto3 moto ];
  propagatedBuildInputs = [ kombu billiard pytz anyjson amqp eventlet ];

  meta = with lib; {
    homepage = https://github.com/celery/celery/;
    description = "Distributed task queue";
    license = licenses.bsd3;
  };
}
