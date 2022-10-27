{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, dacite
, fetchFromGitHub
, aqipy-atmotech
, pytest-asyncio
, pytest-error-for-skips
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "nettigo-air-monitor";
  version = "1.4.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = pname;
    rev = version;
    hash = "sha256-UbknJ+dX+4kzfe6/gg/Nj1Ay8YXtIRj203B6NkhGVys=";
  };

  propagatedBuildInputs = [
    aiohttp
    dacite
    aqipy-atmotech
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
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
