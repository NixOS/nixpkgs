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
  tenacity,
}:

buildPythonPackage rec {
  pname = "nettigo-air-monitor";
  version = "3.1.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = "nettigo-air-monitor";
    rev = "refs/tags/${version}";
    hash = "sha256-9LrzCUstzMTzt2qHzDsllyep5Rtt6vrrvVPRFILUtwA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    aqipy-atmotech
    dacite
    tenacity
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-error-for-skips
    pytestCheckHook
    syrupy
  ];

  disabledTests = [
    # stuck in epoll
    "test_retry_fail"
    "test_retry_success"
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
