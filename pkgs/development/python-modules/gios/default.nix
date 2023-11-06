{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, dacite
, fetchFromGitHub
, pytest-asyncio
, pytest-error-for-skips
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "gios";
  version = "3.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ACWaYXAxLpqfjPG7KngFrErbMKo9iSsW2Yi8V0q9Ie0=";
  };

  propagatedBuildInputs = [
    aiohttp
    dacite
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-error-for-skips
    pytestCheckHook
  ];

  disabledTests = [
    # Test requires network access
    "test_invalid_station_id"
  ];

  pythonImportsCheck = [
    "gios"
  ];

  meta = with lib; {
    description = "Python client for getting air quality data from GIOS";
    homepage = "https://github.com/bieniu/gios";
    changelog = "https://github.com/bieniu/gios/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
