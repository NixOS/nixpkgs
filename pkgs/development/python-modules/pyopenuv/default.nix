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
  version = "2021.10.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "sha256-3zTyW3eXOA9frSAy4g7iWhymc1hBo0hrxIgPLMqrLTs=";
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

  # Ignore the examples as they are prefixed with test_
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
