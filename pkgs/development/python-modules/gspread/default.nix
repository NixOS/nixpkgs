{ lib
, buildPythonPackage
, fetchPypi
, requests
, google-auth
, google-auth-oauthlib
}:

buildPythonPackage rec {
  version = "4.0.1";
  pname = "gspread";

  src = fetchPypi {
    inherit pname version;
    sha256 = "236a0f24e3724b49bae4cbd5144ed036b0ae6feaf5828ad033eb2824bf05e5be";
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
