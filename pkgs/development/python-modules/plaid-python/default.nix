{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  version = "2.3.0";
  pname = "plaid-python";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kp0crzjginmga6qvwwppar5b2pbdvwryf6vdpxgx7kkwzv33w97";
  };

  # Upstream has tests in a makefile, but they're not configured to run in setup.py
  doCheck = false;

  propagatedBuildInputs = [ requests ];

  meta = {
    description = "Python client library for the Plaid API and Link";
    homepage = https://github.com/plaid/plaid-python;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bhipple ];
  };
}
