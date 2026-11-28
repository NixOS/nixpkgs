{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  pytest-aiohttp,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysmartyplants";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "smartyplantstech";
    repo = "pysmartyplants";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bnM2SFU4GYJsDrSwQlz5nXzoznLAWcp+d0G9ruuLBlE=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pysmartyplants" ];

  meta = {
    description = "Async client for the SmartyPlants integration API";
    homepage = "https://github.com/smartyplantstech/pysmartyplants";
    changelog = "https://github.com/smartyplantstech/pysmartyplants/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
