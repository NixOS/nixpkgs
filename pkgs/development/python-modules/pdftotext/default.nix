{ lib, buildPythonPackage, fetchPypi, poppler }:

buildPythonPackage rec {
  pname = "pdftotext";
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c8bdc47b08baa17b8e03ba1f960fc6335b183d2644eaf7300e088516758a6090";
  };

  buildInputs = [ poppler ];

  meta = with lib; {
    description = "Simple PDF text extraction";
    homepage = https://github.com/jalan/pdftotext;
    license = licenses.mit;
    maintainers = with maintainers; [ earvstedt ];
  };
}
