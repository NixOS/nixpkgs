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
}:

buildPythonPackage rec {
  pname = "pytibber";
  version = "0.31.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyTibber";
    tag = version;
    hash = "sha256-qQ/F7SF91wiWelV6kFBDjv5UmrrcD5TmwCsNuG5c25s=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    gql
  ] ++ gql.optional-dependencies.websockets;

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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
