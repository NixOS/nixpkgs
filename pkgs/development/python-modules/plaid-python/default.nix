{ lib
, buildPythonPackage
, fetchPypi
, nulltype
, python-dateutil
, urllib3
}:

buildPythonPackage rec {
  pname = "plaid-python";
  version = "8.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16b23f61deab24d406536a1fd172da77bcbb28b3ca322245b8ee9203350fb57d";
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
