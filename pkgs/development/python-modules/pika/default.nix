{ lib
, buildPythonPackage
, fetchFromGitHub
, gevent
, nose2
, mock
, twisted
, tornado
}:

buildPythonPackage rec {
  pname = "pika";
  version = "1.3.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pika";
    repo = "pika";
    rev = "refs/tags/${version}";
    sha256 = "sha256-iWGqnDj8qhXUOTw8UNC7VHVBNyvMr4Kdk6NubX92KRI=";
  };

  propagatedBuildInputs = [ gevent tornado twisted ];

  checkInputs = [ nose2 mock ];

  postPatch = ''
    # don't stop at first test failure
    # don't run acceptance tests because they access the network
    # don't report test coverage
    substituteInPlace nose2.cfg \
      --replace "stop = 1" "stop = 0" \
      --replace "tests=tests/unit,tests/acceptance" "tests=tests/unit" \
      --replace "with-coverage = 1" "with-coverage = 0"
  '';

  doCheck = false; # tests require rabbitmq instance, unsure how to skip

  checkPhase = ''
    runHook preCheck

    PIKA_TEST_TLS=true nose2 -v

    runHook postCheck
  '';

  meta = with lib; {
    description = "Pure-Python implementation of the AMQP 0-9-1 protocol";
    homepage = "https://pika.readthedocs.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
