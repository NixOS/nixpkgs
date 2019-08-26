{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pdfkit";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lcc1njpjd2zadbljqsnkrvamschl6j099p4giz1jd6mg1ds67gg";
  };

  # tests are not distributed
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/pdfkit;
    description = "Wkhtmltopdf python wrapper to convert html to pdf using the webkit rendering engine and qt";
    license = licenses.mit;
  };

}
