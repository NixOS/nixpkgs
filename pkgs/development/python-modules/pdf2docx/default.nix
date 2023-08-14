{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonRelaxDepsHook
, pytestCheckHook
, pymupdf
, fire
, fonttools
, numpy
, opencv4
, tkinter
, python-docx
}:

buildPythonPackage rec {
  pname = "pdf2docx";
  version = "0.5.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dothinking";
    repo = "pdf2docx";
    rev = "v${version}";
    hash = "sha256-NrT4GURQIJbqnHstfJrPzwLXT9c2oGBi4QJ6eGIFwu4=";
  };

  nativeBuildInputs = [ pytestCheckHook pythonRelaxDepsHook ];
  pythonRemoveDeps = [ "opencv-python" ];

  preBuild = "echo '${version}' > version.txt";

  pytestFlagsArray = [ "-v" "./test/test.py::TestConversion" ];

  # Test fails due to "RuntimeError: cannot find builtin font with name 'Arial'":
  disabledTests = [ "test_unnamed_fonts" ];

  propagatedBuildInputs = [
    tkinter
    pymupdf
    fire
    fonttools
    numpy
    opencv4
    python-docx
  ];

  meta = with lib; {
    description = "Convert PDF to DOCX";
    homepage = "https://github.com/dothinking/pdf2docx";
    changelog = "https://github.com/dothinking/pdf2docx/releases/tag/${src.rev}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ happysalada ];
  };
}
