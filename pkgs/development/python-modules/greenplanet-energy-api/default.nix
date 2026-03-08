{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  pytest-asyncio,
  pytest-cov,
  aioresponses,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "greenplanet-energy-api";
  version = "0.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "petschni";
    repo = "greenplanet-energy-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ffmb4UUVfFhSNAy3Fq+3ERYSfD09JnrR8rKUV0sXjNI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov
    aioresponses
    pytestCheckHook
  ];

  pythonImportsCheck = [ "greenplanet_energy_api" ];

  meta = {
    description = "Async Python library for querying the Green Planet Energy API";
    homepage = "https://github.com/petschni/greenplanet-energy-api";
    changelog = "https://github.com/petschni/greenplanet-energy-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
