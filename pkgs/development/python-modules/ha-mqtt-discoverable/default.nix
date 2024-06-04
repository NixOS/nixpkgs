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
  pythonRelaxDepsHook,
  thelogrus,
}:

buildPythonPackage rec {
  pname = "ha-mqtt-discoverable";
  version = "0.14.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "unixorn";
    repo = "ha-mqtt-discoverable";
    rev = "refs/tags/v${version}";
    hash = "sha256-vL4EzeU+8nUPyLR22MJtLhknWF4DWMo49EKvkIqIWhA=";
  };

  pythonRelaxDeps = [ "pyaml" ];

  build-system = [ poetry-core ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

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
    description = "Python module to create MQTT entities that are automatically discovered by Home Assistant";
    homepage = "https://github.com/unixorn/ha-mqtt-discoverable";
    changelog = "https://github.com/unixorn/ha-mqtt-discoverable/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
