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
  ujson,
  yarl,
}:

buildPythonPackage rec {
  pname = "pyoutbreaksnearme";
  version = "2023.12.0";
  pyproject = true;

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

  meta = {
    description = "Library for retrieving data from for Outbreaks Near Me";
    homepage = "https://github.com/bachya/pyoutbreaksnearme";
    changelog = "https://github.com/bachya/pyoutbreaksnearme/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
