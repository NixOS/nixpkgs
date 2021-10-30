{ lib
, buildPythonPackage
, fetchPypi
, openssl
}:

buildPythonPackage rec {
  pname = "scrypt";
  version = "0.8.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bcf04257af12e6d52974d177a7b08e314b66f350a73f9b6f7b232d69a6a1e041";
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
