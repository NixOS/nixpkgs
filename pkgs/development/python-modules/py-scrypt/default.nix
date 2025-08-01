{
  lib,
  buildPythonPackage,
  fetchPypi,
  openssl,
}:

buildPythonPackage rec {
  pname = "py-scrypt";
  version = "0.8.27";
  format = "setuptools";

  src = fetchPypi {
    pname = "scrypt";
    inherit version;
    hash = "sha256-p7Y3hI7VGMHqKzGp7Kqj9JYWWY2EQt6HBs8fAfur8Kc=";
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
