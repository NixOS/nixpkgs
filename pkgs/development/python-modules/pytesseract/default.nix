{ buildPythonPackage, fetchPypi, lib, pillow, tesseract, substituteAll }:

buildPythonPackage rec {
  pname = "pytesseract";
  version = "0.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wlz1vbg1k8cdrpzvrahjnbsfs4ki6xqhbkv17ycfchh7h6kfkfm";
  };

  patches = [
    (substituteAll {
      src = ./tesseract-binary.patch;
      drv = "${tesseract}";
    })
  ];

  buildInputs = [ tesseract ];
  propagatedBuildInputs = [ pillow ];

  # the package doesn't have any tests.
  doCheck = false;

  meta = with lib; {
    homepage = https://pypi.org/project/pytesseract/;
    license = licenses.gpl3;
    description = "A Python wrapper for Google Tesseract";
    maintainers = with maintainers; [ ma27 ];
  };
}
