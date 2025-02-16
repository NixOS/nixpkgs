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
  thelogrus,
}:

buildPythonPackage rec {
  pname = "ha-mqtt-discoverable";
  version = "0.16.4";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "unixorn";
    repo = "ha-mqtt-discoverable";
    tag = "v${version}";
    hash = "sha256-9JRgg2A/tcZyAkuddQ/v3Dhxe60O47Y4VZY3Yb6/49g=";
  };

  pythonRelaxDeps = [ "pyaml" ];

  build-system = [ poetry-core ];

  dependencies = [
    gitlike-commands
    paho-mqtt
    pyaml
    pydantic
    thelogrus
  ];

  # Test require a running Mosquitto instance
  doCheck = false;

  pythonImportsCheck = [ "ha_mqtt_discoverable" ];

  meta = with lib; {
    # https://github.com/unixorn/ha-mqtt-discoverable/pull/310
    broken = lib.versionAtLeast paho-mqtt.version "2";
    description = "Python module to create MQTT entities that are automatically discovered by Home Assistant";
    homepage = "https://github.com/unixorn/ha-mqtt-discoverable";
    changelog = "https://github.com/unixorn/ha-mqtt-discoverable/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
