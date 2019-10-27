{ lib, fetchPypi, buildPythonPackage, pbkdf2 }:

buildPythonPackage rec {
  pname = "mnemonic";
  version = "0.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02a7306a792370f4a0c106c2cf1ce5a0c84b9dbd7e71c6792fdb9ad88a727f1d";
  };

  propagatedBuildInputs = [ pbkdf2 ];

  meta = {
    description = "Implementation of Bitcoin BIP-0039";
    homepage = https://github.com/trezor/python-mnemonic;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ np ];
  };
}
