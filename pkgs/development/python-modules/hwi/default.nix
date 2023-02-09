{ lib
, buildPythonPackage
, fetchFromGitHub
, bitbox02
, cbor
, ecdsa
, hidapi
, libusb1
, mnemonic
, pyaes
, pyserial
, typing-extensions
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hwi";
  version = "2.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bitcoin-core";
    repo = "HWI";
    rev = version;
    sha256 = "sha256-mLavlJHYU6gUqqc83uHMZfOglrKDIiRNN7Nf2i3fXzE=";
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

  # relax required dependencies:
  # libusb1           - https://github.com/bitcoin-core/HWI/issues/579
  # typing-extensions - https://github.com/bitcoin-core/HWI/issues/572
  postPatch = ''
    substituteInPlace setup.py \
      --replace 'libusb1>=1.7,<3' 'libusb1>=1.7,<4' \
      --replace 'typing-extensions>=3.7,<4.0' 'typing-extensions>=3.7,<5.0'
  '';

  # tests require to clone quite a few firmwares
  doCheck = false;

  pythonImportsCheck = [
    "hwilib"
  ];

  meta = with lib; {
    description = "Bitcoin Hardware Wallet Interface";
    homepage = "https://github.com/bitcoin-core/hwi";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ prusnak ];
  };
}
