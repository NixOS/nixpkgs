{
  lib,
  aiohttp,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  google-auth,
  google-auth-oauthlib,
  mashumaro,
  pytest-aiohttp,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-health-api";
  version = "0.10.0";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "python-google-health-api";
    tag = finalAttrs.version;
    hash = "sha256-iuCbplWZ+OPA5YH81PTFHqIwRRs5DkeHFTgPvQZVYb0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    google-auth
    google-auth-oauthlib
    mashumaro
    requests
  ];

  optional-dependencies.webhook = [ cryptography ];

  nativeCheckInputs = [
    cryptography
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "google_health_api" ];

  meta = {
    description = "Asynchronous, type-safe Python client library for the Google Health API";
    homepage = "https://github.com/allenporter/python-google-health-api";
    changelog = "https://github.com/allenporter/python-google-health-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
