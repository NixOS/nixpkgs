{ lib, buildPythonPackage, fetchPypi, requests, pytest }:

buildPythonPackage rec {
  version = "2.3.4";
  pname = "plaid-python";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fefa30cbd1114844a07b6a37d95fd6657774ce8a551a2ac79641887cd63c72db";
  };

  checkInputs = [ pytest ];
  # Integration tests require API keys and internet access
  checkPhase = "py.test -rxs ./tests/unit";

  propagatedBuildInputs = [ requests ];

  meta = {
    description = "Python client library for the Plaid API and Link";
    homepage = https://github.com/plaid/plaid-python;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bhipple ];
  };
}
