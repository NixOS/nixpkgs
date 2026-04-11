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
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyipma";
  version = "3.0.9";
  pyproject = true;

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

  meta = {
    description = "Library to retrieve information from Instituto Português do Mar e Atmosfera";
    homepage = "https://github.com/dgomes/pyipma";
    changelog = "https://github.com/dgomes/pyipma/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
