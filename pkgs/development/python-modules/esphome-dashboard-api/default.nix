{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, aiohttp
}:

buildPythonPackage rec {
  pname = "esphome-dashboard-api";
  version = "1.2.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "dashboard-api";
    rev = "refs/tags/${version}";
    hash = "sha256-RFfS0xzRXoM6ETXmviiMPxffPzspjTqpkvHOlTJXN9g=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [
    "esphome_dashboard_api"
  ];

  meta = with lib; {
    description = "API to interact with ESPHome Dashboard";
    homepage = "https://github.com/esphome/dashboard-api";
    changelog = "https://github.com/esphome/dashboard-api/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
