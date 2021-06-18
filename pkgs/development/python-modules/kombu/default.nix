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
  version = "5.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01481d99f4606f6939cdc9b637264ed353ee9e3e4f62cfb582324142c41a572d";
  };

  postPatch = ''
    substituteInPlace requirements/test.txt \
      --replace "pytest-sugar" ""
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
