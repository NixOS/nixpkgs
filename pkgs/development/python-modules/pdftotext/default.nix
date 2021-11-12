{ lib, buildPythonPackage, fetchPypi, poppler }:

buildPythonPackage rec {
  pname = "pdftotext";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a067c121654917ecbe07fbd71c807c34bbdb1ea029e269ddd11925ee7e191d3f";
  };

  buildInputs = [ poppler ];

  meta = with lib; {
    description = "Simple PDF text extraction";
    homepage = "https://github.com/jalan/pdftotext";
    license = licenses.mit;
    maintainers = with maintainers; [ earvstedt ];
  };
}
