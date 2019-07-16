{ buildPythonPackage, fetchPypi, lib, pillow, tesseract, substituteAll }:

buildPythonPackage rec {
  pname = "pytesseract";
  version = "0.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vyv6wnch1l5kcxqzngakx948qz90q604bl5h93x54381lq3ndj6";
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
