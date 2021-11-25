{ lib
, buildPythonPackage
, fetchFromGitHub
, bitbox02
, ecdsa
, hidapi
, libusb1
, mnemonic
, pyaes
, typing-extensions
}:

buildPythonPackage rec {
  pname = "hwi";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "bitcoin-core";
    repo = "HWI";
    rev = version;
    sha256 = "sha256-s0pKYqesZjHE6YndqsMwCuqLK7eE82oRiSXxBdUtEX4=";
  };

  propagatedBuildInputs = [
    bitbox02
    ecdsa
    hidapi
    libusb1
    mnemonic
    pyaes
    typing-extensions
  ];

  # make compatible with libusb1 2.x
  postPatch = ''
    substituteInPlace setup.py \
      --replace 'libusb1>=1.7,<2.0' 'libusb1>=1.7'
  '';

  # tests require to clone quite a few firmwares
  doCheck = false;

  pythonImportsCheck = [ "hwilib" ];

  meta = {
    description = "Bitcoin Hardware Wallet Interface";
    homepage = "https://github.com/bitcoin-core/hwi";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
