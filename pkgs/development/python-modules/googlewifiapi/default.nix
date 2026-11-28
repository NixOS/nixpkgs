{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "googlewifiapi";
  version = "0.1.3";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "EReaso";
    repo = "GoogleWifiApi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k+/TEexMU/eFUlT7mxYvzsMM4MQ9k+eSHhs2M2sD1Ik=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    mashumaro
    yarl
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "googlewifiapi" ];

  meta = {
    description = "Asynchronous Python wrapper for the local Google Wifi JSON API";
    homepage = "https://github.com/EReaso/GoogleWifiApi";
    changelog = "https://github.com/EReaso/GoogleWifiApi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
