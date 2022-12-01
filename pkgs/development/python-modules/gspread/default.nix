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
  version = "5.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XznXohg0O2UU8G4iUODEE+tOgU3eaqv0hdrLaqMcqrA=";
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
