{ lib
, buildPythonPackage
, fetchFromGitHub
, bitbox02
, ecdsa
, hidapi
, libusb1
, mnemonic
, pyaes
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "hwi";
  version = "2.0.0";
  disabled = pythonAtLeast "3.9";

  src = fetchFromGitHub {
    owner = "bitcoin-core";
    repo = "HWI";
    rev = version;
    sha256 = "sha256-efEOMvj9Rjctdal5virSrb5QBwmoAyp8nra7K2FXFVU=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'ecdsa>=0.13.0,<0.14.0'" "'ecdsa'" \
      --replace "'hidapi>=0.7.99,<0.8.0'" "'hidapi'" \
      --replace "'mnemonic>=0.18.0,<0.19.0'" "'mnemonic'"
  '';

  propagatedBuildInputs = [
    bitbox02
    ecdsa
    hidapi
    libusb1
    mnemonic
    pyaes
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
