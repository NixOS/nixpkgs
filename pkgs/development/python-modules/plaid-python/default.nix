{ lib, buildPythonPackage, fetchPypi, requests, pytest }:

buildPythonPackage rec {
  version = "2.4.1";
  pname = "plaid-python";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2b7832f9fe0c6cd23dfdb805bcfc52e2ff06fca6604e5782b7518904c1dad6bb";
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
