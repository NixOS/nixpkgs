{ lib, buildPythonPackage, fetchPypi, requests, pytest }:

buildPythonPackage rec {
  version = "4.0.0";
  pname = "plaid-python";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2bf91e4c1054c920ec8911038f86efdc76067bf6b55a9787bd846129ce01ff4a";
  };

  checkInputs = [ pytest ];
  # Integration tests require API keys and internet access
  checkPhase = "py.test -rxs ./tests/unit";

  propagatedBuildInputs = [ requests ];

  meta = {
    description = "Python client library for the Plaid API and Link";
    homepage = "https://github.com/plaid/plaid-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bhipple ];
  };
}
