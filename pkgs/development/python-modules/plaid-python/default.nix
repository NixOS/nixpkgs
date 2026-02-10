{
  lib,
  buildPythonPackage,
  fetchPypi,
  nulltype,
  python-dateutil,
  urllib3,
  setuptools,
}:

buildPythonPackage rec {
  pname = "plaid-python";
  version = "38.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "plaid_python";
    inherit version;
    hash = "sha256-j/AypUXwsaeL6iYjW7xo53wwE+YGMLv8TRwSZ8CeGFk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    nulltype
    python-dateutil
    urllib3
  ];

  # Tests require a Client IP
  doCheck = false;

  pythonImportsCheck = [ "plaid" ];

  meta = {
    description = "Python client library for the Plaid API and Link";
    homepage = "https://github.com/plaid/plaid-python";
    changelog = "https://github.com/plaid/plaid-python/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
  };
}
