{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  bitarray,
  eth-abi,
  eth-keyfile,
  eth-keys,
  eth-rlp,
  eth-utils,
  websockets,
  hexbytes,
  pythonOlder,
  rlp,
}:

buildPythonPackage rec {
  pname = "eth-account";
  version = "0.9.0";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-account";
    rev = "v${version}";
    hash = "sha256-Ps/vzJv0W1+wy1mSJaqRNNU6CoCMchReHIocB9kPrGs=";
  };

  propagatedBuildInputs = [
    bitarray
    eth-abi
    eth-keyfile
    eth-keys
    eth-rlp
    eth-utils
    hexbytes
    rlp
    websockets
  ];

  # require buildinga npm project
  doCheck = false;

  pythonImportsCheck = [ "eth_account" ];

  meta = with lib; {
    description = "Account abstraction library for web3.py";
    homepage = "https://github.com/ethereum/eth-account";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
