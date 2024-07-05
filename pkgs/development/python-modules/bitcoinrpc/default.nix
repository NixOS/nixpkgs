{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  orjson,
  httpx,
  typing-extensions,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "bitcoinrpc";
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

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

  meta = with lib; {
    description = "Bitcoin JSON-RPC client";
    homepage = "https://github.com/bibajz/bitcoin-python-async-rpc";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
