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
  version = "0.31.2";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyTibber";
    tag = version;
    hash = "sha256-/k9XnRgfaE59+Fi/5AhCJt4/jFLdYeDCNaoGCDYGWso=";
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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
