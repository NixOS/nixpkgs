{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  certifi,
  fetchFromGitHub,
  poetry-core,
  pytest-aiohttp,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "regenmaschine";
  version = "2024.03.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bachya";
    repo = "regenmaschine";
    tag = version;
    hash = "sha256-RdmK6oK92j4xqLoAjjqlONYu3IfNNWudo4v7jcc+VGU=";
  };

  nativeBuildInputs = [ poetry-core ];

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

  pythonImportsCheck = [ "regenmaschine" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python library for interacting with RainMachine smart sprinkler controllers";
    homepage = "https://github.com/bachya/regenmaschine";
    changelog = "https://github.com/bachya/regenmaschine/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
