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
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tklecka";
    repo = "pygeosphere-warnings";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gn0OY2H0wUexP9m2RpeMK6LHsC88ceIyyY9YY+dj2A4=";
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
