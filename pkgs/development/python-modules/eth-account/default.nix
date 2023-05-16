{ lib
, buildPythonPackage
, fetchFromGitHub
, bitarray
, eth-abi
, eth-keyfile
, eth-keys
, eth-rlp
, eth-utils
<<<<<<< HEAD
, websockets
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, hexbytes
, pythonOlder
, rlp
}:

buildPythonPackage rec {
  pname = "eth-account";
<<<<<<< HEAD
  version = "0.9.0";
=======
  version = "0.6.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-account";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Ps/vzJv0W1+wy1mSJaqRNNU6CoCMchReHIocB9kPrGs=";
  };

=======
    hash = "sha256-cjQvTKC4lDbKnAvbmnTGHQiJZsZFhXc/+UH5rUdlGxs=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "bitarray>=1.2.1,<1.3.0" "bitarray>=2.4.0,<3"
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    bitarray
    eth-abi
    eth-keyfile
    eth-keys
    eth-rlp
    eth-utils
    hexbytes
    rlp
<<<<<<< HEAD
    websockets
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # require buildinga npm project
  doCheck = false;

  pythonImportsCheck = [ "eth_account" ];

  meta = with lib; {
    description = "Account abstraction library for web3.py";
    homepage = "https://github.com/ethereum/eth-account";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
