{ lib
, buildPythonPackage
, fetchPypi
, requests
, google-auth
, google-auth-oauthlib
}:

buildPythonPackage rec {
  version = "5.1.1";
  pname = "gspread";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d9db8c43d552f541ea072d4727d1e955bc2368b095dd86c5429a845c9d8aed8f";
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
