{ lib, fetchPypi, buildPythonPackage, pbkdf2 }:

buildPythonPackage rec {
  pname = "mnemonic";
  version = "0.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4e37eb02b2cbd56a0079cabe58a6da93e60e3e4d6e757a586d9f23d96abea931";
  };

  propagatedBuildInputs = [ pbkdf2 ];

  meta = {
    description = "Implementation of Bitcoin BIP-0039";
    homepage = https://github.com/trezor/python-mnemonic;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ np ];
  };
}
