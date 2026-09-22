{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
}:

buildPythonPackage (finalAttrs: {
  pname = "cielo-connect-api";
  version = "1.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cielo-connect";
    repo = "cielo-connect-api";
    tag = finalAttrs.version;
    hash = "sha256-rFI3oNv8TYLwSu5Mofg2SjNcfq0WoVoN0KReigLj5ZU=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "cieloconnectapi" ];

  meta = {
    description = "Async Python API client for Cielo Home devices";
    homepage = "https://github.com/cielo-connect/cielo-connect-api";
    changelog = "https://github.com/cielo-connect/cielo-connect-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
