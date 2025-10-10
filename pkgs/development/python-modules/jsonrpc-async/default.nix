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
  version = "2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "emlove";
    repo = "jsonrpc-async";
    rev = version;
    hash = "sha256-KOnycsOZFDEVj8CJDwGbdtbOpMPQMVdrXbHG0fzr9PI=";
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

  meta = with lib; {
    description = "JSON-RPC client library for asyncio";
    homepage = "https://github.com/emlove/jsonrpc-async";
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
