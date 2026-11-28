{
  lib,
  buildPythonPackage,
  fetchPypi,
  nulltype,
  python-dateutil,
  urllib3,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "plaid-python";
  version = "47.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "plaid_python";
    inherit (finalAttrs) version;
    hash = "sha256-fks3OuC6vHQuZz8p+g5iBu/McQP0sRPc9vHr4MwlLmk=";
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
})
