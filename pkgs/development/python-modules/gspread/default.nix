{ stdenv
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  version = "3.3.0";
  pname = "gspread";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nlmg7lnj162nql1acw9z7n1043sk49j11arlfn766i9ykvq6hng";
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
