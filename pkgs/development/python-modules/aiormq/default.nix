{ lib
, aiomisc-pytest
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, pamqp
, yarl
, poetry-core
}:

buildPythonPackage rec {
  pname = "aiormq";
  version = "6.7.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = "aiormq";
    # https://github.com/mosquito/aiormq/issues/189
    rev = "72c44f55313fc14e2a760a45a09831237b64c48d";
    hash = "sha256-IIlna8aQY6bIA7OZHthfvMFFWnf3DDRBP1uiFCD7+Do=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pamqp
    yarl
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    aiomisc-pytest
  ];

  # Tests attempt to connect to a RabbitMQ server
  disabledTestPaths = [
    "tests/test_channel.py"
    "tests/test_connection.py"
  ];

  pythonImportsCheck = [
    "aiormq"
  ];

  meta = with lib; {
    description = "AMQP 0.9.1 asynchronous client library";
    homepage = "https://github.com/mosquito/aiormq";
    changelog = "https://github.com/mosquito/aiormq/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ emilytrau ];
  };
}
