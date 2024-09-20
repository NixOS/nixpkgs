{
  lib,
  buildPythonPackage,
  fetchPypi,
  openssl,
}:

buildPythonPackage rec {
  pname = "py-scrypt";
  version = "0.8.24";

  src = fetchPypi {
    pname = "scrypt";
    inherit version;
    hash = "sha256-mP/eReSpVGHXPe1UunomhXZ5kg1Pj/Mg9vet5uKVMb0=";
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
