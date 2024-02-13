{ lib
, buildPythonPackage
, fetchFromGitHub
, gitlike-commands
, paho-mqtt
, poetry-core
, pyaml
, pydantic
, pythonOlder
, thelogrus
}:

buildPythonPackage rec {
  pname = "ha-mqtt-discoverable";
  version = "0.13.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "unixorn";
    repo = "ha-mqtt-discoverable";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ue8az6Q7uU02IJJyyHk64Ji4J6sf/bShvTeHhN9U92Y=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    gitlike-commands
    paho-mqtt
    pyaml
    pydantic
    thelogrus
  ];

  # Test require a running Mosquitto instance
  doCheck = false;

  pythonImportsCheck = [
    "ha_mqtt_discoverable"
  ];

  meta = with lib; {
    description = "Python module to create MQTT entities that are automatically discovered by Home Assistant";
    homepage = "https://github.com/unixorn/ha-mqtt-discoverable";
    changelog = "https://github.com/unixorn/ha-mqtt-discoverable/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    broken = versionAtLeast pydantic.version "2";
  };
}
