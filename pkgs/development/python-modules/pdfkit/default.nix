{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pdfkit";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "992f821e1e18fc8a0e701ecae24b51a2d598296a180caee0a24c0af181da02a9";
  };

  # tests are not distributed
  doCheck = false;

  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/pdfkit";
    description = "Wkhtmltopdf python wrapper to convert html to pdf using the webkit rendering engine and qt";
    license = licenses.mit;
  };

}
