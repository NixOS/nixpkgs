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
  version = "5.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f4965fba0a4718d47d470beeb5d6446e3357a62402b16c510b6a2f251e05ac3c";
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
