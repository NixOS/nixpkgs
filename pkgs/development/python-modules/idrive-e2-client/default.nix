{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  aiohttp,
  typing-extensions,

  # tests
  aioresponses,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "idrive-e2-client";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "patrickvorgers";
    repo = "idrive-e2-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T/tPFcwowZuAoAdJayWvWoir13U+dOTGxjFfsgrOJCo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    typing-extensions
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "idrive_e2" ];

  meta = {
    description = "Asynchronous client for IDrive e2";
    homepage = "https://github.com/patrickvorgers/idrive-e2-client";
    changelog = "https://github.com/patrickvorgers/idrive-e2-client/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
