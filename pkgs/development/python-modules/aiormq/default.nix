{ lib
, aiomisc-pytest
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, pamqp
, yarl
, setuptools
, poetry-core
, aiomisc
}:

buildPythonPackage rec {
  pname = "aiormq";
  version = "6.7.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-X5Uy1DGxvsyEFR1UgVYqxOX6mESLnNzQl7sVkvzjcw4=";
  };

  nativeBuildInputs = [
    setuptools
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
