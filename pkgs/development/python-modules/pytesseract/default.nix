{ buildPythonPackage
, fetchFromGitHub
, lib
, packaging
, pillow
, tesseract
, substituteAll
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "pytesseract";
  version = "0.3.12";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "madmaze";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-19eLgcvmEFGiyu6v/EzLG8w+jFQL/5rbfDaiQqAGq5g=";
  };

  patches = [
    (substituteAll {
      src = ./tesseract-binary.patch;
      drv = tesseract;
    })
  ];

  nativeBuildInputs = [
    setuptools
  ];

  buildInputs = [
    tesseract
  ];

  propagatedBuildInputs = [
    packaging
    pillow
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://pypi.org/project/pytesseract/";
    license = licenses.asl20;
    description = "A Python wrapper for Google Tesseract";
    maintainers = with maintainers; [ ];
  };
}
