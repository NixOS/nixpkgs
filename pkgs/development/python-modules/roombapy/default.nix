{ lib
, amqtt
, buildPythonPackage
, fetchFromGitHub
, orjson
, paho-mqtt
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "roombapy";
  version = "1.6.8";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pschmitt";
    repo = "roombapy";
    rev = "refs/tags/${version}";
    hash = "sha256-z9D9FiE+14/x05AFu3EpBYlAqpDPc5y6S+pLTsSO0cU=";
  };

  postPatch = ''
    # hbmqtt was replaced by amqtt
    substituteInPlace tests/test_roomba_integration.py \
      --replace "from hbmqtt.broker import Broker" "from amqtt.broker import Broker"

    substituteInPlace pyproject.toml \
      --replace 'orjson = ">=3.8.7"' 'orjson = "*"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    orjson
    paho-mqtt
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
    homepage = "https://github.com/pschmitt/roombapy";
    changelog = "https://github.com/pschmitt/roombapy/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
