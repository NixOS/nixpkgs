{ lib
, buildPythonPackage
, fetchPypi
, requests
, google-auth
, google-auth-oauthlib
, pythonOlder
}:

buildPythonPackage rec {
  pname = "gspread";
  version = "5.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hiDph+U0AxXyuNjSbPl+RzaoSzMloXx9m8/3BSXcMAM=";
  };

  propagatedBuildInputs = [
    requests
    google-auth
    google-auth-oauthlib
  ];

  # No tests included
  doCheck = false;

  pythonImportsCheck = [
    "gspread"
  ];

  meta = with lib; {
    description = "Google Spreadsheets client library";
    homepage = "https://github.com/burnash/gspread";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
