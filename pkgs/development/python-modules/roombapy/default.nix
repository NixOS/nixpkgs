{
  lib,
  amqtt,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  mashumaro,
  orjson,
  paho-mqtt,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  tabulate,
}:

buildPythonPackage rec {
  pname = "roombapy";
  version = "1.9.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "pschmitt";
    repo = "roombapy";
    tag = version;
    hash = "sha256-fcCK6yby9Jfc4lSSETn13Y+4A3qjvYfm4Ps3T5yG4Rc=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  pythonRelaxDeps = [ "orjson" ];

  propagatedBuildInputs = [
    mashumaro
    orjson
    paho-mqtt
  ];

  optional-dependencies.cli = [
    click
    tabulate
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

  pythonImportsCheck = [ "roombapy" ];

  meta = with lib; {
    description = "Python program and library to control Wi-Fi enabled iRobot Roombas";
    mainProgram = "roombapy";
    homepage = "https://github.com/pschmitt/roombapy";
    changelog = "https://github.com/pschmitt/roombapy/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
