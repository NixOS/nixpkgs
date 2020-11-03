{ lib, buildPythonPackage, fetchPypi, requests, pytest }:

buildPythonPackage rec {
  version = "6.0.0";
  pname = "plaid-python";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a0ay39k50hbxxaxz09m2azz5c08yqki2gincziv6g381yrlj68s";
  };

  checkInputs = [ pytest ];

  # Integration tests require API keys and internet access
  checkPhase = "py.test -rxs ./tests/unit";

  requiredPythonModules = [ requests ];

  meta = {
    description = "Python client library for the Plaid API and Link";
    homepage = "https://github.com/plaid/plaid-python";
    changelog = "https://github.com/plaid/plaid-python/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bhipple ];
  };
}
