{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  backoff,
  yarl,
  aresponses,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiomodernforms";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wonderslug";
    repo = "aiomodernforms";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KSCADrZJgoXTo6+k3fVd0eQzattKmmT8HYyEAogrGDU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    backoff
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "aiomodernforms" ];

  meta = {
    changelog = "https://github.com/wonderslug/aiomodernforms/releases/tag/${finalAttrs.src.tag}";
    description = "Asynchronous Python client for Modern Forms fans";
    homepage = "https://github.com/wonderslug/aiomodernforms";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
