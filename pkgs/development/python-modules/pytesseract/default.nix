{ buildPythonPackage, fetchFromGitHub, lib, packaging, pillow, tesseract, substituteAll
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytesseract";
  version = "0.3.10";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "madmaze";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CyKXtaIE/8iPLqi0GHVUgTeJDYZyWBjkRvOKJJKCxZo=";
  };

  patches = [
    (substituteAll {
      src = ./tesseract-binary.patch;
      drv = tesseract;
    })
  ];

  buildInputs = [
    tesseract
  ];

  propagatedBuildInputs = [
    packaging
    pillow
  ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://pypi.org/project/pytesseract/";
    license = licenses.asl20;
    description = "A Python wrapper for Google Tesseract";
    maintainers = with maintainers; [ ];
  };
}
