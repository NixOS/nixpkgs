{ buildPythonPackage, fetchPypi, lib, pillow, tesseract, substituteAll }:

buildPythonPackage rec {
  pname = "pytesseract";
  version = "0.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0w4phjw0gn52hqlm3ixs2cmj25x7y7nk6ijr9f82wvjvb4hh7hhi";
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
