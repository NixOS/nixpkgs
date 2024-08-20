{
  lib,
  aiomisc-pytest,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  pamqp,
  yarl,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "aiormq";
  version = "6.8.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = "aiormq";
    rev = "refs/tags/${version}";
    hash = "sha256-XD1g4JXQJlJyXuZbo4hYW7cwQhy8+p4/inwNw2WOD9Y=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  pythonRelaxDeps = [ "pamqp" ];

  propagatedBuildInputs = [
    pamqp
    yarl
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [ aiomisc-pytest ];

  # Tests attempt to connect to a RabbitMQ server
  disabledTestPaths = [
    "tests/test_channel.py"
    "tests/test_connection.py"
  ];

  pythonImportsCheck = [ "aiormq" ];

  meta = with lib; {
    description = "AMQP 0.9.1 asynchronous client library";
    homepage = "https://github.com/mosquito/aiormq";
    changelog = "https://github.com/mosquito/aiormq/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ emilytrau ];
  };
}
