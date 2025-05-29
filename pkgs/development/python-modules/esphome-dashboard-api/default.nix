{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  orjson,
}:

buildPythonPackage rec {
  pname = "esphome-dashboard-api";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "dashboard-api";
    tag = version;
    hash = "sha256-b3PnMzlA9N8NH6R5ed6wf5QF45i887iQk2QgH7e755k=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    orjson
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "esphome_dashboard_api" ];

  meta = with lib; {
    description = "API to interact with ESPHome Dashboard";
    homepage = "https://github.com/esphome/dashboard-api";
    changelog = "https://github.com/esphome/dashboard-api/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
