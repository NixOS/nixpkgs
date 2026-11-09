{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pdfkit";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mS+CHh4Y/IoOcB7K4ktRotWYKWoYDK7gokwK8YHaAqk=";
  };

  # tests are not distributed
  doCheck = false;

  meta = {
    homepage = "https://pypi.org/project/pdfkit/";
    description = "Wkhtmltopdf python wrapper to convert html to pdf using the webkit rendering engine and qt";
    license = lib.licenses.mit;
  };
}
