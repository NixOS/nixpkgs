{
  lib,
  buildPythonPackage,
  fetchPypi,
  pkgs,
  six,
}:

buildPythonPackage rec {
  pname = "ecdsa";
  version = "0.19.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-R4y6e2JVWGb8s7s/6YXgbey9to71VxPE5auYxX1QjmE=";
  };

  propagatedBuildInputs = [ six ];
  # Only needed for tests
  nativeCheckInputs = [ pkgs.openssl ];

  meta = with lib; {
    description = "ECDSA cryptographic signature library";
    homepage = "https://github.com/warner/python-ecdsa";
    license = licenses.mit;
  };
}
