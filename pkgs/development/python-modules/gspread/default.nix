{ lib
, buildPythonPackage
, fetchPypi
, requests
, google-auth
, google-auth-oauthlib
}:

buildPythonPackage rec {
  version = "5.0.0";
  pname = "gspread";

  src = fetchPypi {
    inherit pname version;
    sha256 = "55dd9e257ad45c479aed9283e5abe8d517a0c4e2dd443bf0a9849b53f826c0ca";
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
