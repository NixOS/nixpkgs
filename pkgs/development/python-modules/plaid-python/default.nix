{ lib, buildPythonPackage, fetchPypi, requests, pytest }:

buildPythonPackage rec {
  version = "2.3.0";
  pname = "plaid-python";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kp0crzjginmga6qvwwppar5b2pbdvwryf6vdpxgx7kkwzv33w97";
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
