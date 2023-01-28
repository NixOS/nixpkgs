{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, freezegun
, mock
, geopy
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyipma";
  version = "3.0.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dgomes";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-KyXHNkP/XJlTdVFdP91x3udMquQju8G2VUHLPvZymtk=";
  };

  propagatedBuildInputs = [
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

  pythonImportsCheck = [
    "pyipma"
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/test_auxiliar.py"
    "tests/test_location.py"
    "tests/test_sea_forecast.py"
  ];

  meta = with lib; {
    description = "Library to retrieve information from Instituto Português do Mar e Atmosfera";
    homepage = "https://github.com/dgomes/pyipma";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
