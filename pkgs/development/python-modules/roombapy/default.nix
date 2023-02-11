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

  nativeCheckInputs = [
    amqtt
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    # hbmqtt was replaced by amqtt
    substituteInPlace tests/test_roomba_integration.py \
      --replace "from hbmqtt.broker import Broker" "from amqtt.broker import Broker"
  '';

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
    maintainers = [ ];
  };
}
