{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, jsonrpc-base
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jsonrpc-async";
  version = "2.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "emlove";
    repo = pname;
    rev = version;
    hash = "sha256-Lr8gvQR0Q46b/e1K/XyvqtJo18nBpHjlDdNq4vjCMyU=";
  };

  propagatedBuildInputs = [
    aiohttp
    jsonrpc-base
  ];

  checkInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  patches = [
    # Fix tests with later pytest-aiohttp, https://github.com/emlove/jsonrpc-async/pull/9
    (fetchpatch {
      name = "support-later-pytest-aiohttp.patch";
      url = "https://github.com/emlove/jsonrpc-async/commit/8b790f23af0d898df90460029d5ba3bcfb0423ed.patch";
      sha256 = "sha256-rthHRF90hywMIbvIHo3Do/uzXKe+STPOoZIa80H4b/g=";
    })
  ];

  pytestFlagsArray = [
    "tests.py"
  ];

  pythonImportsCheck = [
    "jsonrpc_async"
  ];

  meta = with lib; {
    description = "A JSON-RPC client library for asyncio";
    homepage = "https://github.com/emlove/jsonrpc-async";
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
