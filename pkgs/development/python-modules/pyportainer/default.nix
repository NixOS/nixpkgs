{
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  mashumaro,
  orjson,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyportainer";
  version = "1.0.29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "erwindouna";
    repo = "pyportainer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NfK6Ce99bXtI0QgObdsalpTf9MiaOBdWOp6nTrAipY4=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  pythonImportsCheck = [ "pyportainer" ];

  nativeCheckInputs = [
    aresponses
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  meta = {
    changelog = "https://github.com/erwindouna/pyportainer/releases/tag/${finalAttrs.src.tag}";
    description = "Asynchronous Python client for the Portainer API";
    homepage = "https://github.com/erwindouna/pyportainer";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
