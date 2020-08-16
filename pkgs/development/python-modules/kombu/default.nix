{ lib, buildPythonPackage, fetchPypi
, amqp
, botocore
, case
, Pyro4
, pytest
, pytz
, sqlalchemy
, importlib-metadata
, pythonOlder
}:

buildPythonPackage rec {
  pname = "kombu";
  version = "5.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7c949fe33573a971f06c8836ca025390088f3747533b78438f9a57344a142b59";
  };

  postPatch = ''
    substituteInPlace requirements/test.txt \
      --replace "pytest-sugar" ""
    substituteInPlace requirements/default.txt \
      --replace "amqp==2.5.1" "amqp~=2.5"
  '';

  propagatedBuildInputs = [
    amqp
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [ botocore pytest case pytz Pyro4 sqlalchemy ];
  # test_redis requires fakeredis, which isn't trivial to package
  checkPhase = ''
    pytest --ignore t/unit/transport/test_redis.py
  '';

  meta = with lib; {
    description = "Messaging library for Python";
    homepage    = "https://github.com/celery/kombu";
    license     = licenses.bsd3;
  };
}
