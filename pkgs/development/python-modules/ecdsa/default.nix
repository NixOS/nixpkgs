{ lib, stdenv
, buildPythonPackage
, fetchPypi
, pkgs
, six
}:

buildPythonPackage rec {
  pname = "ecdsa";
  version = "0.16.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cfc046a2ddd425adbd1a78b3c46f0d1325c657811c0f45ecc3a0a6236c1e50ff";
  };

  propagatedBuildInputs = [ six ];
  # Only needed for tests
  checkInputs = [ pkgs.openssl ];

  meta = with lib; {
    description = "ECDSA cryptographic signature library";
    homepage = "https://github.com/warner/python-ecdsa";
    license = licenses.mit;
  };

}
