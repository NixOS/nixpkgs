{ lib
, amqtt
, buildPythonPackage
, fetchFromGitHub
, orjson
, paho-mqtt
, poetry-core
, pydantic
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "roombapy";
  version = "1.7.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "pschmitt";
    repo = "roombapy";
    rev = "refs/tags/${version}";
    hash = "sha256-vB6+cGqeHFthCbz4q75EwsHb8w1H2vPSaKdtvquh5Kc=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "orjson"
  ];

  propagatedBuildInputs = [
    orjson
    paho-mqtt
    pydantic
  ];

  nativeCheckInputs = [
    amqtt
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Requires network access
    "tests/test_discovery.py"
  ];

  disabledTests = [
    # Test want to connect to a local MQTT broker
    "test_roomba_connect"
  ];

  pythonImportsCheck = [
    "roombapy"
  ];

  meta = with lib; {
    description = "Python program and library to control Wi-Fi enabled iRobot Roombas";
    mainProgram = "roombapy";
    homepage = "https://github.com/pschmitt/roombapy";
    changelog = "https://github.com/pschmitt/roombapy/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
