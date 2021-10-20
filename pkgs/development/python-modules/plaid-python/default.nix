{ lib
, buildPythonPackage
, fetchPypi
, nulltype
, python-dateutil
, urllib3
}:

buildPythonPackage rec {
  pname = "plaid-python";
  version = "8.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13gj4xb0lx2dgdkcdp7fvvql3vjr572qpa1m993z3p7n5c27j5xi";
  };

  propagatedBuildInputs = [
    nulltype
    python-dateutil
    urllib3
  ];

  # Tests require a Client IP
  doCheck = false;

  pythonImportsCheck = [
    "plaid"
  ];

  meta = with lib; {
    description = "Python client library for the Plaid API and Link";
    homepage = "https://github.com/plaid/plaid-python";
    changelog = "https://github.com/plaid/plaid-python/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
