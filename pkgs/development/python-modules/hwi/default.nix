{
  lib,
  bitbox02,
  buildPythonPackage,
  cbor,
  ecdsa,
  fetchFromGitHub,
  hidapi,
  libusb1,
  mnemonic,
  pyaes,
  pyserial,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "hwi";
  version = "3.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bitcoin-core";
    repo = "HWI";
    tag = version;
    hash = "sha256-utNt0qaHNP6tzkhDnAMjwwNCKoMo3504oozdRpXnDEw=";
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

  # Tests require to clone quite a few firmwares
  doCheck = false;

  pythonImportsCheck = [ "hwilib" ];

  meta = {
    description = "Bitcoin Hardware Wallet Interface";
    homepage = "https://github.com/bitcoin-core/hwi";
    changelog = "https://github.com/bitcoin-core/HWI/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
