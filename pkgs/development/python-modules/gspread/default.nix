{ stdenv
, buildPythonPackage
, fetchPypi
, requests
, google_auth
}:

buildPythonPackage rec {
  version = "3.6.0";
  pname = "gspread";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e04f1a6267b3929fc1600424c5ec83906d439672cafdd61a9d5b916a139f841c";
  };

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "Google Spreadsheets client library";
    homepage = "https://github.com/burnash/gspread";
    license = licenses.mit;
    # missing multiple google libraries
    broken = true; # 2020-08-15
  };

  # No tests included
  doCheck = false;

}
