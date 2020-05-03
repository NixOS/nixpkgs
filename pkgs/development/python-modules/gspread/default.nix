{ stdenv
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  version = "3.3.1";
  pname = "gspread";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mpvhndr38hb5x95xk2mqqasvcy6pa7ck8801bvpg5y3lwn5nka0";
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
