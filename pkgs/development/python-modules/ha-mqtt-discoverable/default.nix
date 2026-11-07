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
  version = "0.26.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Home-Assistant-Tooling";
    repo = "ha-mqtt-discoverable";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ftlLESG+XbYCjwPbvIzHhKqmrwwo6sTJwI9EFDo0ddM=";
  };

  pythonRelaxDeps = [
    "paho-mqtt"
    "pyaml"
    "pydantic"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "poetry-core>=2.5.0" "poetry-core"
  '';

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
    homepage = "https://github.com/Home-Assistant-Tooling/ha-mqtt-discoverable";
    changelog = "https://github.com/Home-Assistant-Tooling/ha-mqtt-discoverable/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
