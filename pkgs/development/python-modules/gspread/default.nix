{ lib
, buildPythonPackage
, fetchPypi
, requests
, google-auth
, google-auth-oauthlib
}:

buildPythonPackage rec {
  version = "5.5.0";
  pname = "gspread";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hiDph+U0AxXyuNjSbPl+RzaoSzMloXx9m8/3BSXcMAM=";
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
