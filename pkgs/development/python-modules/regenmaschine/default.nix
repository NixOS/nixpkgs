{ lib
, aiohttp
, aresponses
, buildPythonPackage
, certifi
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
  version = "2024.01.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = "regenmaschine";
    rev = "refs/tags/${version}";
    hash = "sha256-Vd8ACF2AXbT7FE/b0koIPUrNd9DgmjgS5unBuRiq784=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    certifi
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
