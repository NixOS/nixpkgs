{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  aioresponses,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mitsubishi-comfort";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nikolairahimi";
    repo = "mitsubishi-comfort";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O/HAPb7MYU0/LEVS4ynddQuN6HKZUOUKWFn/CMz2q5E=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mitsubishi_comfort" ];

  meta = {
    description = "Async Python library for Mitsubishi minisplit control via Kumo Cloud and local API";
    homepage = "https://github.com/nikolairahimi/mitsubishi-comfort";
    changelog = "https://github.com/nikolairahimi/mitsubishi-comfort/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
