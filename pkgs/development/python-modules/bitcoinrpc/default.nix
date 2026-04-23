{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  orjson,
  httpx,
  setuptools,
  typing-extensions,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage (finalAttrs: {
  pname = "bitcoinrpc";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bibajz";
    repo = "bitcoin-python-async-rpc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QrLAhX2OZNP6k6TZ7OkD9phQidsExbep8MxWxQpqAU8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    orjson
    httpx
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTestPaths = [ "tests/test_connection.py" ];

  pythonImportsCheck = [ "bitcoinrpc" ];

  meta = {
    description = "Bitcoin JSON-RPC client";
    homepage = "https://github.com/bibajz/bitcoin-python-async-rpc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
