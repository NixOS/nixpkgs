{ lib, buildPythonPackage, fetchPypi, requests, pytest }:

buildPythonPackage rec {
  version = "7.4.0";
  pname = "plaid-python";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ab70467116adc110b56eb5a1fdeed726307cc216e04dda46a782aa1a1468ce0e";
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
