{ lib
, aiohttp
, aresponses
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
  version = "2023.05.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-u6GHDiTGa7v9tK/4VTVPQL/2kjomo0x/EGC7LD8lMvM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    typing-extensions
  ];

  nativeCheckInputs = [
    aresponses
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
