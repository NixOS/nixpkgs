{ lib
, buildPythonPackage
, fetchPypi
, nulltype
, python-dateutil
, urllib3
}:

buildPythonPackage rec {
  pname = "plaid-python";
  version = "8.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zvwqMpI/aufZLf9dSVEDY2Letiyso8oSf9o5kanXW7U=";
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
