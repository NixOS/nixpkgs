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
<<<<<<< HEAD
  version = "0.3.12";
=======
  version = "0.3.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "madmaze";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-19eLgcvmEFGiyu6v/EzLG8w+jFQL/5rbfDaiQqAGq5g=";
=======
    rev = "v${version}";
    hash = "sha256-CyKXtaIE/8iPLqi0GHVUgTeJDYZyWBjkRvOKJJKCxZo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
