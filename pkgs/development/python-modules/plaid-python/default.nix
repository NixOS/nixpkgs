{ lib
, buildPythonPackage
, fetchPypi
, nulltype
, python-dateutil
, urllib3
}:

buildPythonPackage rec {
  pname = "plaid-python";
  version = "8.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8930949bd43e3126289f50e927d1acacf53c57ec3227c764e0c1feb72bbb61a3";
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
