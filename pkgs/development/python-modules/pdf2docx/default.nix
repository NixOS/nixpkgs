{
  stdenv,
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pip,
  pytestCheckHook,
  pymupdf,
  fire,
  fonttools,
  numpy,
  opencv4,
  tkinter,
  python-docx,
}:
let
  version = "0.5.8";
in
buildPythonPackage {
  pname = "pdf2docx";
  inherit version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dothinking";
    repo = "pdf2docx";
    rev = "refs/tags/v${version}";
    hash = "sha256-tMITDm2NkxWS+H/hhd2LlaPbyuI86ZKaALqqHJqb8V0=";
  };

  nativeBuildInputs = [
    pip
  ];

  pythonRemoveDeps = [ "opencv-python" ];

  preBuild = "echo '${version}' > version.txt";

  propagatedBuildInputs = [
    tkinter
    pymupdf
    fire
    fonttools
    numpy
    opencv4
    python-docx
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [
    "-v"
    "./test/test.py::TestConversion"
  ];

  # Test fails due to "RuntimeError: cannot find builtin font with name 'Arial'":
  disabledTests = [ "test_unnamed_fonts" ];

  meta = with lib; {
    description = "Convert PDF to DOCX";
    mainProgram = "pdf2docx";
    homepage = "https://github.com/dothinking/pdf2docx";
    changelog = "https://github.com/dothinking/pdf2docx/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ happysalada ];
  };
}
