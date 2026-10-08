{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitlike-commands,
  paho-mqtt,
  poetry-core,
  pyaml,
  pydantic,
}:

buildPythonPackage (finalAttrs: {
  pname = "ha-mqtt-discoverable";
  version = "0.25.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "unixorn";
    repo = "ha-mqtt-discoverable";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7MZDzaGJExEBjNjqjIyYWrnoGbt/dVbWlNkU33jvvU0=";
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

  meta = {
    description = "Python module to create MQTT entities that are automatically discovered by Home Assistant";
    homepage = "https://github.com/unixorn/ha-mqtt-discoverable";
    changelog = "https://github.com/unixorn/ha-mqtt-discoverable/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
