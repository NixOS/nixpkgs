{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  gql,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytibber";
  version = "0.37.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyTibber";
    tag = finalAttrs.version;
    hash = "sha256-ZM9oXX6iEmsR20f2Jgg3fME1lm3egKun1GvNOZIKTV0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    gql
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
