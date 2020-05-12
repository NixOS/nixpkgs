{ buildPythonPackage, fetchPypi, lib, pillow, tesseract, substituteAll }:

buildPythonPackage rec {
  pname = "pytesseract";
  version = "0.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16l9b9f5v0a9j5jfgpd8irk9yhc9byzirrzv1rlkapdbz36sbn5g";
  };

  patches = [
    (substituteAll {
      src = ./tesseract-binary.patch;
      drv = tesseract;
    })
  ];

  buildInputs = [ tesseract ];
  propagatedBuildInputs = [ pillow ];

  # the package doesn't have any tests.
  doCheck = false;

  meta = with lib; {
    homepage = "https://pypi.org/project/pytesseract/";
    license = licenses.asl20;
    description = "A Python wrapper for Google Tesseract";
    maintainers = with maintainers; [ ma27 ];
  };
}
