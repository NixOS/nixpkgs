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
  version = "1.2.1";
  disabled = pythonAtLeast "3.9";

  src = fetchFromGitHub {
    owner = "bitcoin-core";
    repo = "HWI";
    rev = version;
    sha256 = "0fs3152lw7y5l9ssr5as8gd739m9lb7wxpv1vc5m77k5nw7l8ax5";
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
