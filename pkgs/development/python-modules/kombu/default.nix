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
  version = "4.6.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "437b9cdea193cc2ed0b8044c85fd0f126bb3615ca2f4d4a35b39de7cacfa3c1a";
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
