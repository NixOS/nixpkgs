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
  version = "6.8.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = "aiormq";
    tag = version;
    hash = "sha256-3+PoDB5Owy8BWBUisX0i1mV8rqs5K9pBFQwup8vKxlg=";
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
