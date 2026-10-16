{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  gql,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  tenacity,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytibber";
  version = "0.38.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyTibber";
    tag = finalAttrs.version;
    hash = "sha256-8b13QG0BHy53xj7N2yDju53ZKfjGpNbe0rUEopPAfVQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    gql
    tenacity
    websockets
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Tests access network
    "test/test_tibber.py"
  ];

  pythonImportsCheck = [ "tibber" ];

  meta = {
    description = "Python library to communicate with Tibber";
    homepage = "https://github.com/Danielhiversen/pyTibber";
    changelog = "https://github.com/Danielhiversen/pyTibber/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
