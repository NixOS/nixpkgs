{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  jinja2,
  poetry-core,
  pytest,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "meraki";
  version = "2.0.3";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "meraki";
    repo = "dashboard-api-python";
    tag = version;
    hash = "sha256-dAy295DB213TotVkVGvLYIzzHk1M9PycMNgyX+wD7ms=";
  };

  pythonRelaxDeps = [
    "pytest"
    "setuptools"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    jinja2
    pytest
    requests
    setuptools
  ];

  # All tests require an API key
  doCheck = false;

  pythonImportsCheck = [ "meraki" ];

  meta = {
    description = "Cisco Meraki cloud-managed platform dashboard API python library";
    homepage = "https://github.com/meraki/dashboard-api-python";
    changelog = "https://github.com/meraki/dashboard-api-python/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dylanmtaylor ];
  };
}
