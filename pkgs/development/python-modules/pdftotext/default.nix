{ lib, buildPythonPackage, fetchPypi, poppler }:

buildPythonPackage rec {
  pname = "pdftotext";
  version = "2.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "98aeb8b07a4127e1a30223bd933ef080bbd29aa88f801717ca6c5618380b8aa6";
  };

  buildInputs = [ poppler ];

  meta = with lib; {
    description = "Simple PDF text extraction";
    homepage = "https://github.com/jalan/pdftotext";
    license = licenses.mit;
    maintainers = with maintainers; [ earvstedt ];
  };
}
