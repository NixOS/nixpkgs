{ lib, buildPythonPackage, fetchPypi, poppler }:

buildPythonPackage rec {
  pname = "pdftotext";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "efbbfb14cf37ed7ab2c71936bae44707dfed6bb3be7ea5214e9c44c8c258c7af";
  };

  buildInputs = [ poppler ];

  meta = with lib; {
    description = "Simple PDF text extraction";
    homepage = "https://github.com/jalan/pdftotext";
    license = licenses.mit;
    maintainers = with maintainers; [ earvstedt ];
  };
}
