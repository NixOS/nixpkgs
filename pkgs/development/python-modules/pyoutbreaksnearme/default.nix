{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  certifi,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
  ujson,
  yarl,
}:

buildPythonPackage rec {
  pname = "pyoutbreaksnearme";
  version = "2023.12.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = "pyoutbreaksnearme";
    tag = version;
    hash = "sha256-oR/DApOxNSSczrBeH4sytd/vasbD4rA1poW4zNoeAnU=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    certifi
    ujson
    yarl
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-aiohttp
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Ignore the examples directory as the files are prefixed with test_.
    "examples/"
  ];

  pythonImportsCheck = [ "pyoutbreaksnearme" ];

  meta = with lib; {
    description = "Library for retrieving data from for Outbreaks Near Me";
    homepage = "https://github.com/bachya/pyoutbreaksnearme";
    changelog = "https://github.com/bachya/pyoutbreaksnearme/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
