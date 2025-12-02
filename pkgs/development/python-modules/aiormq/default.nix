{
  lib,
  aiomisc-pytest,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pamqp,
  yarl,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "aiormq";
  version = "6.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = "aiormq";
    tag = version;
    hash = "sha256-ApwL3okhpc3Dtq4bfWCCnoikyRx+4zPI9XtJ+qPKQdg=";
  };

  pythonRelaxDeps = [ "pamqp" ];

  build-system = [ poetry-core ];

  dependencies = [
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
