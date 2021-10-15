{ lib, buildPythonPackage, fetchPypi, requests, pytest }:

buildPythonPackage rec {
  version = "8.3.0";
  pname = "plaid-python";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b11779042bf6dcf1474a35a88bc52959ee41f1deeedcc6667b4d740a5627f28d";
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
