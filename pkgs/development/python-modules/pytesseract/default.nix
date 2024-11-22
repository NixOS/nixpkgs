{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  packaging,
  pillow,
  tesseract,
  substituteAll,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytesseract";
  version = "0.3.13";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "madmaze";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-gQMeck6ojlIwyiOCBBhzHHrjQfBMelVksVGd+fyxWZk=";
  };

  patches = [
    (substituteAll {
      src = ./tesseract-binary.patch;
      drv = tesseract;
    })
  ];

  nativeBuildInputs = [ setuptools ];

  buildInputs = [ tesseract ];

  propagatedBuildInputs = [
    packaging
    pillow
  ];
  disabledTests = [
    # https://github.com/madmaze/pytesseract/pull/559
    "incorrect_tessdata_dir"
    "invalid_tessdata_dir"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://pypi.org/project/pytesseract/";
    license = licenses.asl20;
    description = "Python wrapper for Google Tesseract";
    mainProgram = "pytesseract";
    maintainers = [ ];
  };
}
