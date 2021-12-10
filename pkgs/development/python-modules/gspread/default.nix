{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, google-auth
, google-auth-oauthlib
}:

buildPythonPackage rec {
  version = "4.0.1";
  pname = "gspread";

  src = fetchFromGitHub {
     owner = "burnash";
     repo = "gspread";
     rev = "v4.0.1";
     sha256 = "1cp4lvp9552mv1xx353a9mh2m7iq8llncwj3l7ds8nf91465hsfg";
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
