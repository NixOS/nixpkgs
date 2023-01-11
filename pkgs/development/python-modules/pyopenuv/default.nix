{ lib
, aiohttp
, aresponses
, asynctest
, backoff
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyopenuv";
  version = "2023.01.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-qPLfah35E0vX2tQhGw4wTSMyE4nIyWMDIaKlJePVSd4=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    backoff
  ];

  checkInputs = [
    aresponses
    asynctest
    pytest-asyncio
    pytest-aiohttp
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Ignore the examples as they are prefixed with test_
    "examples/"
  ];

  pythonImportsCheck = [
    "pyopenuv"
  ];

  meta = with lib; {
    description = "Python API to retrieve data from openuv.io";
    homepage = "https://github.com/bachya/pyopenuv";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
