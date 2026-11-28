{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-aiohttp,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "hydropeak-opendata";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Beat-YT";
    repo = "hydropeak-opendata";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZCzLvkgNttcwI6G6DlJWKfxaJMNrnEQGngfflJlMo4w=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "hydropeak_opendata" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Asynchronous client for Hydro-Quebec peak events open data";
    homepage = "https://github.com/Beat-YT/hydropeak-opendata";
    changelog = "https://github.com/Beat-YT/hydropeak-opendata/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
