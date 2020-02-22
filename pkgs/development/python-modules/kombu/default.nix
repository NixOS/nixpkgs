{ lib, buildPythonPackage, fetchPypi
, amqp
, case
, Pyro4
, pytest
, pytz
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "kombu";
  version = "4.6.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "67b32ccb6fea030f8799f8fd50dd08e03a4b99464ebc4952d71d8747b1a52ad1";
  };

  postPatch = ''
    substituteInPlace requirements/test.txt \
      --replace "pytest-sugar" ""
    substituteInPlace requirements/default.txt \
      --replace "amqp==2.5.1" "amqp~=2.5"
  '';

  propagatedBuildInputs = [ amqp ];

  checkInputs = [ pytest case pytz Pyro4 sqlalchemy ];
  # test_redis requires fakeredis, which isn't trivial to package
  checkPhase = ''
    pytest --ignore t/unit/transport/test_redis.py
  '';

  meta = with lib; {
    description = "Messaging library for Python";
    homepage    = https://github.com/celery/kombu;
    license     = licenses.bsd3;
  };
}
