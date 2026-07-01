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
  pytestCheckHook,
  yarl,
}:

buildPythonPackage rec {
  pname = "aiowatttime";
  version = "2024.06.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bachya";
    repo = "aiowatttime";
    tag = version;
    hash = "sha256-c5L+Nx+CoWEc6Bs61GOHPBelExe5I7EOlMQ+QV6nktI=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    certifi
    yarl
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  # Ignore the examples directory as the files are prefixed with test_
  disabledTestPaths = [ "examples/" ];

  pythonImportsCheck = [ "aiowatttime" ];

  meta = {
    description = "Python library for interacting with WattTime";
    homepage = "https://github.com/bachya/aiowatttime";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
