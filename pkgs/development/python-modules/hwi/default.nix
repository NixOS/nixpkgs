{ lib
<<<<<<< HEAD
, bitbox02
, buildPythonPackage
, cbor
, ecdsa
, fetchFromGitHub
=======
, buildPythonPackage
, fetchFromGitHub
, bitbox02
, cbor
, ecdsa
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, hidapi
, libusb1
, mnemonic
, pyaes
, pyserial
<<<<<<< HEAD
, pythonOlder
, typing-extensions
=======
, typing-extensions
, pythonOlder
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "hwi";
<<<<<<< HEAD
  version = "2.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

=======
  version = "2.2.1";
  format = "setuptools";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "bitcoin-core";
    repo = "HWI";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-V4BWB4mCONQ8kjAy6ySonAbCUTaKpBTvhSnHmoH8TQM=";
=======
    hash = "sha256-vQJN2YXWGvYSVV9lemZyu61inc9iBFxf5nIlpIiRe+s=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    bitbox02
    cbor
    ecdsa
    hidapi
    libusb1
    mnemonic
    pyaes
    pyserial
    typing-extensions
  ];

<<<<<<< HEAD
  # Tests require to clone quite a few firmwares
=======
  # relax required dependencies:
  # libusb1           - https://github.com/bitcoin-core/HWI/issues/579
  # typing-extensions - https://github.com/bitcoin-core/HWI/issues/572
  postPatch = ''
    substituteInPlace setup.py \
      --replace 'libusb1>=1.7,<3' 'libusb1>=1.7,<4' \
      --replace 'typing-extensions>=3.7,<4.0' 'typing-extensions>=3.7,<5.0'
  '';

  # tests require to clone quite a few firmwares
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  doCheck = false;

  pythonImportsCheck = [
    "hwilib"
  ];

  meta = with lib; {
    description = "Bitcoin Hardware Wallet Interface";
    homepage = "https://github.com/bitcoin-core/hwi";
<<<<<<< HEAD
    changelog = "https://github.com/bitcoin-core/HWI/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ prusnak ];
  };
}
