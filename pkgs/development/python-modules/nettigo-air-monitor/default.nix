{ lib
, aiohttp
, aioresponses
, aqipy-atmotech
, buildPythonPackage
, dacite
, fetchFromGitHub
, orjson
, pytest-asyncio
, pytest-error-for-skips
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "nettigo-air-monitor";
  version = "1.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = pname;
    rev = version;
    hash = "sha256-86YEpn3rI6Y4v0pcNk+/4tHCUzXpXZN5xwV9M/1gZ8U=";
  };

  propagatedBuildInputs = [
    aiohttp
    aqipy-atmotech
    dacite
    orjson
  ];

  checkInputs = [
    aioresponses
    pytest-asyncio
    pytest-error-for-skips
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "nettigo_air_monitor"
  ];

  meta = with lib; {
    description = "Python module to get air quality data from Nettigo Air Monitor devices";
    homepage = "https://github.com/bieniu/nettigo-air-monitor";
    changelog = "https://github.com/bieniu/nettigo-air-monitor/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
