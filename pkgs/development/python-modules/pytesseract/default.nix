{ buildPythonPackage, fetchPypi, lib, pillow, tesseract, substituteAll }:

buildPythonPackage rec {
  pname = "pytesseract";
  version = "0.2.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mjr3pa4fycdsl7xk9s8fpn2vhpgx7mrdnn5h4lyyjhz86195ivg";
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
    homepage = https://pypi.org/project/pytesseract/;
    license = licenses.gpl3;
    description = "A Python wrapper for Google Tesseract";
    maintainers = with maintainers; [ ma27 ];
  };
}
