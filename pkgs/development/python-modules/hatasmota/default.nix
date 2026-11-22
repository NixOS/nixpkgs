{
  lib,
  aiohttp,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  voluptuous,
}:

buildPythonPackage (finalAttrs: {
  pname = "hatasmota";
  version = "0.10.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "emontnemery";
    repo = "hatasmota";
    tag = finalAttrs.version;
    hash = "sha256-IIOXpgBlXzeOUCvyEYAuEYzvoCKzhWSud1GbgTpa8wU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    attrs
    voluptuous
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "hatasmota" ];

  meta = {
    description = "Python module to help parse and construct Tasmota MQTT messages";
    homepage = "https://github.com/emontnemery/hatasmota";
    changelog = "https://github.com/emontnemery/hatasmota/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
