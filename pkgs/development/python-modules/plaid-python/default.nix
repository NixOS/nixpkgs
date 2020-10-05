{ lib, buildPythonPackage, fetchPypi, requests, pytest }:

buildPythonPackage rec {
  version = "6.1.0";
  pname = "plaid-python";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bdcb336495e2fa60d3de521a7504e709e3630b8509244bc990a245a46302813";
  };

  checkInputs = [ pytest ];

  # Integration tests require API keys and internet access
  checkPhase = "py.test -rxs ./tests/unit";

  propagatedBuildInputs = [ requests ];

  meta = {
    description = "Python client library for the Plaid API and Link";
    homepage = "https://github.com/plaid/plaid-python";
    changelog = "https://github.com/plaid/plaid-python/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bhipple ];
  };
}
