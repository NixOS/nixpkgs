{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiolyric";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "aiolyric";
    tag = finalAttrs.version;
    hash = "sha256-+OYMe63sX5TtvJpNn6dzvnephlhS/MyFXmUerYZqF5A=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "packaging"
  ];

  dependencies = [
    aiohttp
    packaging
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiolyric" ];

  disabledTestPaths = [
    # _version file is no shipped
    "tests/test__version.py"
  ];

  meta = {
    description = "Python module for the Honeywell Lyric Platform";
    homepage = "https://github.com/timmo001/aiolyric";
    changelog = "https://github.com/timmo001/aiolyric/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
