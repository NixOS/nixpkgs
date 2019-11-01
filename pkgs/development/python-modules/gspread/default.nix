{ stdenv
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  version = "3.1.0";
  pname = "gspread";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f7ce6c06250f694976c3cd4944e3b607b0810b93383839e5b67c7199ce2f0d3d";
  };

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "Google Spreadsheets client library";
    homepage = "https://github.com/burnash/gspread";
    license = licenses.mit;
  };

  # No tests included
  doCheck = false;

}
