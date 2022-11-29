{ lib
, aiohttp
, aresponses
, asynctest
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-aiohttp
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "regenmaschine";
  version = "2022.11.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-Sm9gd5ezqrgcpDYJlFyEtzFmY29MbdY+pjWu6c86Rfg=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    typing-extensions
  ];

  checkInputs = [
    aresponses
    asynctest
    pytest-aiohttp
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Examples are prefix with test_
    "examples/"
  ];

  pythonImportsCheck = [
    "regenmaschine"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Python library for interacting with RainMachine smart sprinkler controllers";
    homepage = "https://github.com/bachya/regenmaschine";
    changelog = "https://github.com/bachya/regenmaschine/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
