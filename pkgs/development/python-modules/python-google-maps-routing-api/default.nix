{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  mashumaro,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-google-maps-routing-api";
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tronikos";
    repo = "python-google-maps-routing-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rpdedeU/2MQ9dESsVPD90vgWeN9emx48G1i1IooZyiM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    mashumaro
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "google_maps_routing_api" ];

  meta = {
    description = "Python client library for Google Maps Routes API";
    homepage = "https://github.com/tronikos/python-google-maps-routing-api";
    changelog = "https://github.com/tronikos/python-google-maps-routing-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
