{ lib, buildPythonPackage, fetchPypi, poppler }:

buildPythonPackage rec {
  pname = "pdftotext";
  version = "2.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2a9aa89bc62022408781b39d188fabf5a3ad1103b6630f32c4e27e395f7966ee";
  };

  buildInputs = [ poppler ];

  meta = with lib; {
    description = "Simple PDF text extraction";
    homepage = "https://github.com/jalan/pdftotext";
    license = licenses.mit;
    maintainers = with maintainers; [ erikarvstedt ];
  };
}
