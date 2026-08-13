{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  aioresponses,
  orjson,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "bond-async";
  version = "0.2.1";

  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bondhome";
    repo = "bond-async";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YRJHUOYFLf4dtQGIFKHLdUQxWTnZzG1MPirMsGvDor8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    orjson
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bond_async" ];

  meta = {
    description = "Asynchronous Python wrapper library over Bond Local API";
    homepage = "https://github.com/bondhome/bond-async";
    changelog = "https://github.com/bondhome/bond-async/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
