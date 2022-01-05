{ lib
, amqtt
, buildPythonPackage
, fetchFromGitHub
, paho-mqtt
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "roombapy";
  version = "1.6.5";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pschmitt";
    repo = "roombapy";
    rev = version;
    sha256 = "sha256-Xjeh29U+FCzI5n/i5s6wC0B88Ktmb8pnNDdOzCiKWi4=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    paho-mqtt
  ];

  checkInputs = [
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
    homepage = "https://github.com/pschmitt/roombapy";
    license = licenses.mit;
    maintainers = with maintainers; [ justinas ];
  };
}
