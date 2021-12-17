{ lib, buildPythonPackage, fetchPypi, poppler }:

buildPythonPackage rec {
  pname = "pdftotext";
  version = "2.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Kpqom8YgIkCHgbOdGI+r9aOtEQO2Yw8yxOJ+OV95Zu4=";
  };

  buildInputs = [ poppler ];

  meta = with lib; {
    description = "Simple PDF text extraction";
    homepage = "https://github.com/jalan/pdftotext";
    license = licenses.mit;
    maintainers = with maintainers; [ earvstedt ];
  };
}
