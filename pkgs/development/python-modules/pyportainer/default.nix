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
  tenacity,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyportainer";
  version = "1.0.34";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "erwindouna";
    repo = "pyportainer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qa+NbX8y/2bK3B7gHWuTeAKT0bTaZS2HbWS/75a8tcA=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    tenacity
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
