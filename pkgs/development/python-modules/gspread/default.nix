{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "3.0.1";
  pname = "gspread";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cc06b22c6a1b6726925defcd41c19ce6cd5ab939252e72759bdf0353e36f552";
  };

  meta = with stdenv.lib; {
    description = "Google Spreadsheets client library";
    homepage = "https://github.com/burnash/gspread";
    license = licenses.mit;
  };

}
