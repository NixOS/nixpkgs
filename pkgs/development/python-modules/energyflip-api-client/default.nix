{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  yarl,
  anyio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "energyflip-api-client";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DieEneSchrodinger";
    repo = "energyflip-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R8JEdU0z9sVNF/kMaQoKIHLFHR4W/B0YrXbSoYM/M8k=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    anyio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "energyflip" ];

  meta = {
    description = "Client for EnergyFlip API";
    homepage = "https://github.com/DieEneSchrodinger/energyflip-client";
    changelog = "https://github.com/DieEneSchrodinger/energyflip-client/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
