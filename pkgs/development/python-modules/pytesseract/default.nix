{ buildPythonPackage, fetchPypi, lib, pillow, tesseract, substituteAll }:

buildPythonPackage rec {
  pname = "pytesseract";
  version = "0.3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4ecfc898d00a70fcc38d2bce729de1597c67e7bc5d2fa26094714c9f5b573645";
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
