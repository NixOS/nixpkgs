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
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Beat-YT";
    repo = "hydropeak-opendata";
    tag = "v${finalAttrs.version}";
    hash = "sha256-09f8SjY3OEYU3PkOHFjsUmqKNw+hCi/ZY56f7UjZ7w0=";
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
