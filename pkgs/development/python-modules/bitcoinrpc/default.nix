{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  orjson,
  httpx,
  typing-extensions,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bitcoinrpc";
  version = "0.5.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bibajz";
    repo = "bitcoin-python-async-rpc";
    rev = "v${version}";
    hash = "sha256-uxkSz99X9ior7l825PaXGIC5XJzO/Opv0vTyY1ixvxU=";
  };

  propagatedBuildInputs = [
    orjson
    httpx
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bitcoinrpc" ];

  meta = {
    description = "Bitcoin JSON-RPC client";
    homepage = "https://github.com/bibajz/bitcoin-python-async-rpc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
