{ lib, buildPythonPackage, fetchPypi, poppler }:

buildPythonPackage rec {
  pname = "pdftotext";
  version = "2.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "caf8ddbaeaf0a5897f07655a71747242addab2e695e84c5d47f2ea92dfe2a594";
  };

  buildInputs = [ poppler ];

  meta = with lib; {
    description = "Simple PDF text extraction";
    homepage = "https://github.com/jalan/pdftotext";
    license = licenses.mit;
    maintainers = with maintainers; [ earvstedt ];
  };
}
