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
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hwi";
  version = "2.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

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
      --replace 'libusb1>=1.7,<2.0' 'libusb1>=1.7' \
      --replace "'python_requires': '>=3.6,<3.10'," "'python_requires': '>=3.6,<4'," \
      --replace 'typing-extensions>=3.7,<4.0' 'typing-extensions>=3.7'
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
