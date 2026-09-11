{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pygeosphere-warnings";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tklecka";
    repo = "pygeosphere-warnings";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AQ2TQk5N+S4bW0OmrZj0la2UMIdpmxBUCMhbIkszm3g=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pygeosphere_warnings" ];

  meta = {
    description = "Asynchronous Python client for the GeoSphere Austria Warn API";
    homepage = "https://github.com/tklecka/pygeosphere-warnings";
    changelog = "https://github.com/tklecka/pygeosphere-warnings/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
