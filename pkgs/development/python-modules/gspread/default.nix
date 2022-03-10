{ lib
, buildPythonPackage
, fetchPypi
, requests
, google-auth
, google-auth-oauthlib
}:

buildPythonPackage rec {
  version = "5.2.0";
  pname = "gspread";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-JRc6wIFGnPnWIVFMZXbGz0bznIJfF4uMueeDdKY3sL8=";
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
