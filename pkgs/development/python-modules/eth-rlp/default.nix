{ lib
, buildPythonPackage
, fetchFromGitHub
, eth-hash
, eth-utils
, hexbytes
, pytestCheckHook
, pythonOlder
, rlp
}:

buildPythonPackage rec {
  pname = "eth-rlp";
  version = "0.3.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-rlp";
    rev = "v${version}";
    hash = "sha256-wfmRjHFu6H3J6hNin8ZA2454xXrLgcUdeR8iGXFomRE=";
  };

  propagatedBuildInputs = [
    hexbytes
    eth-utils
    rlp
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ eth-hash.optional-dependencies.pycryptodome;

  pythonImportsCheck = [ "eth_rlp" ];

  meta = with lib; {
    description = "RLP definitions for common Ethereum objects";
    homepage = "https://github.com/ethereum/eth-rlp";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
