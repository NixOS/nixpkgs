{ lib
, buildPythonPackage
, fetchPypi
, requests
, google-auth
, google-auth-oauthlib
}:

buildPythonPackage rec {
  version = "3.7.0";
  pname = "gspread";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4bda4ab8c5edb9e41cf4ae40d4d5fb30447522b4e43608e05c01351ab1b96912";
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
