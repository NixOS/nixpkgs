{ lib
, buildPythonPackage
, fetchPypi
, openssl
}:

buildPythonPackage rec {
  pname = "scrypt";
  version = "0.8.20";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DSJsHGdE+y4wizkUEGabHfXP6CY3/8te1Im/grLS63g=";
  };

  buildInputs = [ openssl ];
  doCheck = false;

  meta = with lib; {
    description = "Bindings for scrypt key derivation function library";
    homepage = "https://pypi.python.org/pypi/scrypt";
    maintainers = [];
    license = licenses.bsd2;
  };
}
