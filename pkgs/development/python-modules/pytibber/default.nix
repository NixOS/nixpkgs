{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  gql,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  websockets,
}:

buildPythonPackage rec {
  pname = "pytibber";
  version = "0.31.5";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyTibber";
    tag = version;
    hash = "sha256-U6WMBX7p0dHQ7vEbw3lmFmysWEcoSbojG2dVZik9gA4=";
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

  # Tests access network
  doCheck = false;

  pythonImportsCheck = [ "tibber" ];

  meta = {
    description = "Python library to communicate with Tibber";
    homepage = "https://github.com/Danielhiversen/pyTibber";
    changelog = "https://github.com/Danielhiversen/pyTibber/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
