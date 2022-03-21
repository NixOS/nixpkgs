{ buildPythonPackage, fetchPypi, lib, pillow, tesseract, substituteAll, packaging }:

buildPythonPackage rec {
  pname = "pytesseract";
  version = "0.3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fiuvx/SNG7cUQ85GM6VvXiGSWpjyIKNsM2KX7c0ZVtA=";
  };

  patches = [
    (substituteAll {
      src = ./tesseract-binary.patch;
      drv = tesseract;
    })
  ];

  buildInputs = [ tesseract ];
  propagatedBuildInputs = [ pillow packaging ];

  # the package doesn't have any tests.
  doCheck = false;

  meta = with lib; {
    homepage = "https://pypi.org/project/pytesseract/";
    license = licenses.asl20;
    description = "A Python wrapper for Google Tesseract";
    maintainers = with maintainers; [ ma27 ];
  };
}
