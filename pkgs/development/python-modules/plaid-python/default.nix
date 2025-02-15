{
  lib,
  buildPythonPackage,
  fetchPypi,
  nulltype,
  python-dateutil,
  urllib3,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "plaid-python";
  version = "29.0.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "plaid_python";
    inherit version;
    hash = "sha256-/HznxgYQvNxyAbYrvDK1yq8crZcd3fH5j9n2XmfGWTY=";
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

  meta = with lib; {
    description = "Python client library for the Plaid API and Link";
    homepage = "https://github.com/plaid/plaid-python";
    changelog = "https://github.com/plaid/plaid-python/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
