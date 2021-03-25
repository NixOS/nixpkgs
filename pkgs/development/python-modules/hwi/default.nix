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
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "bitcoin-core";
    repo = "HWI";
    rev = version;
    sha256 = "0m8maxhjpfxnkry2l0x8143m1gmds8mbwyd9flnkfipxz0r0xwbr";
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
