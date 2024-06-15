{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  eth-hash,
  eth-utils,
  hexbytes,
  pytestCheckHook,
  pythonOlder,
  rlp,
}:

buildPythonPackage rec {
  pname = "eth-rlp";
  version = "2.1.0";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-rlp";
    rev = "v${version}";
    hash = "sha256-FTqIutndf+epmO5XNEUoRAUEmn299aTLIZNe5SMcxAQ=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    hexbytes
    eth-utils
    rlp
  ];

  nativeCheckInputs = [ pytestCheckHook ] ++ eth-hash.optional-dependencies.pycryptodome;

  pythonImportsCheck = [ "eth_rlp" ];

  meta = with lib; {
    description = "RLP definitions for common Ethereum objects";
    homepage = "https://github.com/ethereum/eth-rlp";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
