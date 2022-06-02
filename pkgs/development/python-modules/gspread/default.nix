{ lib
, buildPythonPackage
, fetchPypi
, requests
, google-auth
, google-auth-oauthlib
}:

buildPythonPackage rec {
  version = "5.3.2";
  pname = "gspread";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MZdm2Q2wUFYpP37grSs1UDoaQGg6dYl6KSI5jNIBYoM=";
  };

  propagatedBuildInputs = [ requests google-auth google-auth-oauthlib ];

  meta = with lib; {
    description = "Google Spreadsheets client library";
    homepage = "https://github.com/burnash/gspread";
    license = licenses.mit;
  };

  # No tests included
  doCheck = false;

}
