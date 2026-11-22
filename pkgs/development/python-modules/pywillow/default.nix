{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hatchling,
  aiohttp,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pywillow";
  version = "0.1.2";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "PlantWithWillow";
    repo = "pywillow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lulXzZH+73usepnsJm2qilfGjp5BGH3xdLDMkiEic6w=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pywillow" ];

  meta = {
    description = "Async Python client for the Willow plant sensor API";
    homepage = "https://github.com/PlantWithWillow/pywillow";
    changelog = "https://github.com/PlantWithWillow/pywillow/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
