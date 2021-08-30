{ lib, buildPythonPackage, fetchPypi, requests, pytest }:

buildPythonPackage rec {
  version = "8.1.0";
  pname = "plaid-python";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b1f7b5b58ba3c171bb795352119d54797c8c50877bc376d26cd756de2453e9fd";
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
