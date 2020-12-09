{ lib
, buildPythonPackage
, fetchPypi
, mnemonic
, ecdsa
, typing-extensions
, hidapi
, libusb1
, pyaes
, trezor
, btchip
, ckcc-protocol
}:

buildPythonPackage rec {
  pname = "hwi";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d0d220a4967d7f106b828b12a98b78c220d609d7cc6c811898e24fcf1a6f04f3";
  };

  propagatedBuildInputs = [
    mnemonic
    ecdsa
    typing-extensions
    hidapi
    libusb1
    pyaes
    trezor
    btchip
    ckcc-protocol
  ];

  patches = [ ./relax-deps.patch ];

  # tests are not packaged in the released tarball
  doCheck = false;

  pythonImportsCheck = [
    "hwilib"
  ];

  meta = {
    description = "Bitcoin Hardware Wallet Interface";
    homepage = "https://github.com/bitcoin-core/hwi";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
