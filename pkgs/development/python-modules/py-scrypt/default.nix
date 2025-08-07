{
  lib,
  buildPythonPackage,
  fetchPypi,
  openssl,
}:

buildPythonPackage rec {
  pname = "py-scrypt";
  version = "0.9.4";
  format = "setuptools";

  src = fetchPypi {
    pname = "scrypt";
    inherit version;
    hash = "sha256-DSEgELqMLlVHW6YljzDO5NoEMgF1FNj26FW38fjFXHc=";
  };

  buildInputs = [ openssl ];
  doCheck = false;

  meta = with lib; {
    description = "Bindings for scrypt key derivation function library";
    homepage = "https://pypi.python.org/pypi/scrypt";
    maintainers = [ ];
    license = licenses.bsd2;
  };
}
