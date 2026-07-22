{
  lib,
  buildPythonPackage,
  fetchFromCodeberg,
  hatchling,
  aiohttp,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "data-grand-lyon-ha";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "Crocmagnon";
    repo = "data_grand_lyon_ha";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cxyfvHeX59cHuxpQEy2kUhaObm7n0EF0MZTrGw17uik=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "data_grand_lyon_ha" ];

  meta = {
    description = "Python library to retrieve data from Grand Lyon open data platform, for Home Assistant";
    homepage = "https://codeberg.org/Crocmagnon/data_grand_lyon_ha";
    changelog = "https://codeberg.org/Crocmagnon/data_grand_lyon_ha/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
