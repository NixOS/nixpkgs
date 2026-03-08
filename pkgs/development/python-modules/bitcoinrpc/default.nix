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
  version = "0.7.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bibajz";
    repo = "bitcoin-python-async-rpc";
    tag = "v${version}";
    hash = "sha256-QrLAhX2OZNP6k6TZ7OkD9phQidsExbep8MxWxQpqAU8=";
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
