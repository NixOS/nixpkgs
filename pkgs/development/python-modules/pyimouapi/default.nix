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
  version = "1.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Imou-OpenPlatform";
    repo = "Py-Imou-Open-Api";
    tag = finalAttrs.version;
    hash = "sha256-g70zYBmhQXlk1EUExqWuHWDenx8ZCcnMvh8wo1hLS4g=";
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
    changelog = "https://github.com/Imou-OpenPlatform/Py-Imou-Open-Api/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
