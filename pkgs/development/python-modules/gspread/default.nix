{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "0.2.3";
  pname = "gspread";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dba45ef9e652dcd8cf561ae65569bd6ecd18fcc77b991521490698fb2d847106";
  };

  meta = with stdenv.lib; {
    description = "Google Spreadsheets client library";
    homepage = "https://github.com/burnash/gspread";
    license = licenses.mit;
  };

}
