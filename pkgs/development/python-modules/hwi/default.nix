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
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eec460a51eb556500c1eca92015be246d5714cd53171407a76da71e4346048ae";
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
