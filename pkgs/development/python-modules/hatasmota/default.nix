{
  lib,
  aiohttp,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "hatasmota";
  version = "0.10.1";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "emontnemery";
    repo = "hatasmota";
    tag = version;
    hash = "sha256-Be6W7+DMpMXezEQDkEN9+ei7cJXP1bGIURuXlMNyR0Y=";
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

  meta = with lib; {
    description = "Python module to help parse and construct Tasmota MQTT messages";
    homepage = "https://github.com/emontnemery/hatasmota";
    changelog = "https://github.com/emontnemery/hatasmota/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
