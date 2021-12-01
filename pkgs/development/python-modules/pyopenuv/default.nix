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
  version = "2021.11.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "sha256-J0YIq00/GcWEL23UHmN98Jp/imOAz8NLzhMdk8WFozk=";
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
