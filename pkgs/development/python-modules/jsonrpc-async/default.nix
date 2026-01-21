{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  jsonrpc-base,
  pytest-aiohttp,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jsonrpc-async";
  version = "2.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "emlove";
    repo = "jsonrpc-async";
    tag = version;
    hash = "sha256-WcO2mj5QYZTMnFTNo1ABgpJPxM+GREVIf+z9viFDJHM=";
  };

  patches = [
    # https://github.com/emlove/jsonrpc-async/pull/11
    ./mark-tests-async.patch
  ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    jsonrpc-base
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests.py" ];

  pythonImportsCheck = [ "jsonrpc_async" ];

  meta = {
    description = "JSON-RPC client library for asyncio";
    homepage = "https://github.com/emlove/jsonrpc-async";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
