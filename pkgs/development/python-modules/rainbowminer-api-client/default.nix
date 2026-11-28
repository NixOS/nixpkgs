{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  setuptools-scm,
  aiohttp,
  pydantic,
  yarl,
  pytest-aiohttp,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "rainbowminer-api-client";
  version = "0.2.3";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "El1t3Mult1pl3x0r";
    repo = "rainbowminer-api-client";
    tag = finalAttrs.version;
    hash = "sha256-OP9TzxU3RgK2tXnVsaLub7aLWZ5Cp42+/dUvVxm1RmY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiohttp
    pydantic
    yarl
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rainbowminer_api_client" ];

  meta = {
    description = "Python API client for the RainbowMiner multipool cryptominer";
    homepage = "https://github.com/El1t3Mult1pl3x0r/rainbowminer-api-client";
    changelog = "https://github.com/El1t3Mult1pl3x0r/rainbowminer-api-client/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
