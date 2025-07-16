{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitlike-commands,
  paho-mqtt,
  poetry-core,
  pyaml,
  pydantic,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "ha-mqtt-discoverable";
  version = "0.20.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "unixorn";
    repo = "ha-mqtt-discoverable";
    tag = "v${version}";
    hash = "sha256-XaaL5O6WHIs+9vNq/IqolPUsL04l6PCKTZNBTYH1z4g=";
  };

  pythonRelaxDeps = [
    "paho-mqtt"
    "pyaml"
    "pydantic"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    gitlike-commands
    paho-mqtt
    pyaml
    pydantic
  ];

  # Test require a running Mosquitto instance
  doCheck = false;

  pythonImportsCheck = [ "ha_mqtt_discoverable" ];

  meta = with lib; {
    description = "Python module to create MQTT entities that are automatically discovered by Home Assistant";
    homepage = "https://github.com/unixorn/ha-mqtt-discoverable";
    changelog = "https://github.com/unixorn/ha-mqtt-discoverable/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
