{ stdenv
, buildPythonPackage
, fetchPypi
, requests
, google-auth
, google-auth-oauthlib
}:

buildPythonPackage rec {
  version = "3.6.0";
  pname = "gspread";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e04f1a6267b3929fc1600424c5ec83906d439672cafdd61a9d5b916a139f841c";
  };

  propagatedBuildInputs = [ requests google-auth google-auth-oauthlib ];

  meta = with stdenv.lib; {
    description = "Google Spreadsheets client library";
    homepage = "https://github.com/burnash/gspread";
    license = licenses.mit;
  };

  # No tests included
  doCheck = false;

}
