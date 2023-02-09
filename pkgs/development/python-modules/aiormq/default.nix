{ lib
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
  version = "6.6.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = pname;
    rev = version;
    sha256 = "+zTSaQzBoIHDUQgOpD6xvoruFFHZBb0z5D6uAUo0W5A=";
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
    aiomisc
  ];
  # Tests attempt to connect to a RabbitMQ server
  disabledTestPaths = [
    "tests/test_channel.py"
    "tests/test_connection.py"
  ];
  pythonImportsCheck = [ "aiormq" ];

  meta = with lib; {
    description = "AMQP 0.9.1 asynchronous client library";
    homepage = "https://github.com/mosquito/aiormq";
    license = licenses.asl20;
    maintainers = with maintainers; [ emilytrau ];
  };
}
