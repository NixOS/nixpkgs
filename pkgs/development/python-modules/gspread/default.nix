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
  version = "5.7.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-znb5wWuIzLeSNQFCIkpZr6jmn3Rj89NBcUjL6JLvx8s=";
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
    changelog = "https://github.com/burnash/gspread/blob/v${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
