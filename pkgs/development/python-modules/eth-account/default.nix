{ lib
, buildPythonPackage
, fetchFromGitHub
, bitarray
, eth-abi
, eth-keyfile
, eth-keys
, eth-rlp
, eth-utils
, hexbytes
, pythonOlder
, rlp
}:

buildPythonPackage rec {
  pname = "eth-account";
  version = "0.6.1";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-account";
    rev = "v${version}";
    hash = "sha256-cjQvTKC4lDbKnAvbmnTGHQiJZsZFhXc/+UH5rUdlGxs=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "bitarray>=1.2.1,<1.3.0" "bitarray>=2.4.0,<3"
  '';

  propagatedBuildInputs = [
    bitarray
    eth-abi
    eth-keyfile
    eth-keys
    eth-rlp
    eth-utils
    hexbytes
    rlp
  ];

  # require buildinga npm project
  doCheck = false;

  pythonImportsCheck = [ "eth_account" ];

  meta = with lib; {
    description = "Account abstraction library for web3.py";
    homepage = "https://github.com/ethereum/eth-account";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
