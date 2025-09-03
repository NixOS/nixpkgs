{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  mock,
  geopy,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyipma";
  version = "3.0.9";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "dgomes";
    repo = "pyipma";
    tag = version;
    hash = "sha256-1EUOkNwNoZQEetJ5v6httas0S0a3bHLv/lDRXQsT/Ds=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    geopy
  ];

  nativeCheckInputs = [
    aioresponses
    freezegun
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyipma" ];

  disabledTestPaths = [
    # Tests require network access
    "tests/test_auxiliar.py"
    "tests/test_location.py"
    "tests/test_sea_forecast.py"
  ];

  meta = with lib; {
    description = "Library to retrieve information from Instituto Português do Mar e Atmosfera";
    homepage = "https://github.com/dgomes/pyipma";
    changelog = "https://github.com/dgomes/pyipma/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
