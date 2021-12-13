{ lib
, buildPythonPackage
, fetchPypi
, nulltype
, python-dateutil
, urllib3
}:

buildPythonPackage rec {
  pname = "plaid-python";
  version = "8.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8689b5c4d69e93026aea252314fb3133359fa70df5819ad6995c4e44a2f84858";
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
