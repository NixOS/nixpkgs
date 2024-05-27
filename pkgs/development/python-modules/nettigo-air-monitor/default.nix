{
  lib,
  aiohttp,
  aioresponses,
  aqipy-atmotech,
  buildPythonPackage,
  dacite,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-error-for-skips,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  syrupy,
}:

buildPythonPackage rec {
  pname = "nettigo-air-monitor";
  version = "3.0.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = "nettigo-air-monitor";
    rev = "refs/tags/${version}";
    hash = "sha256-Ysvyg2cj09Bb+xpNPapYAQSBDKfGsYZcHj9xxIR8KGw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    aqipy-atmotech
    dacite
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-error-for-skips
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "nettigo_air_monitor" ];

  meta = with lib; {
    description = "Python module to get air quality data from Nettigo Air Monitor devices";
    homepage = "https://github.com/bieniu/nettigo-air-monitor";
    changelog = "https://github.com/bieniu/nettigo-air-monitor/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
