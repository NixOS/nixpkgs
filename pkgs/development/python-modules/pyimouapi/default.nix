{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
  setuptools,
  simpleeval,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyimouapi";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Imou-OpenPlatform";
    repo = "Py-Imou-Open-Api";
    tag = finalAttrs.version;
    hash = "sha256-/ZGaJubdeEe5d4wnzrS/e6hPC5i/IRccgYc34su2iw4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    simpleeval
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyimouapi" ];

  meta = {
    description = "Async Python client for the Imou Open Platform cloud APIs";
    homepage = "https://github.com/Imou-OpenPlatform/Py-Imou-Open-Api";
    changelog = "https://github.com/Imou-OpenPlatform/Py-Imou-Open-Api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
