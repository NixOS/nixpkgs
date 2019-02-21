{ lib, buildPythonPackage, fetchPypi, requests, pytest }:

buildPythonPackage rec {
  version = "2.4.0";
  pname = "plaid-python";

  src = fetchPypi {
    inherit pname version;
    sha256 = "734fe8328b7fc9a52f8e204b4cce99dd475fe5add784a57fdf0f0cb99eb752a0";
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
