{ lib, buildPythonPackage, fetchPypi, poppler }:

buildPythonPackage rec {
  pname = "pdftotext";
  version = "2.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00xf3jmpb4m3q758wvk4khpcmiys4gmd88vvrz6i7yw1jl268y6k";
  };

  buildInputs = [ poppler ];

  meta = with lib; {
    description = "Simple PDF text extraction";
    homepage = https://github.com/jalan/pdftotext;
    license = licenses.mit;
    maintainers = with maintainers; [ earvstedt ];
  };
}
