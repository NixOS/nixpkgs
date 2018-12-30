{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pdfkit";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1p1m6gp51ql3wzjs2iwds8sc3hg1i48yysii9inrky6qc3s6q5vf";
  };

  # tests are not distributed
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/pdfkit;
    description = "Wkhtmltopdf python wrapper to convert html to pdf using the webkit rendering engine and qt";
    license = licenses.mit;
  };

}
