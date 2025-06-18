{
  lib,
  buildPythonPackage,
  fetchPypi,
  poppler,
}:

buildPythonPackage rec {
  pname = "pdftotext";
  version = "3.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-w2UrGRVOFFUVqL+pU/xhNjOO2SM3vcy7U/4NiAE7Gqo=";
  };

  buildInputs = [ poppler ];

  meta = with lib; {
    description = "Simple PDF text extraction";
    homepage = "https://github.com/jalan/pdftotext";
    license = licenses.mit;
    maintainers = with maintainers; [ erikarvstedt ];
  };
}
