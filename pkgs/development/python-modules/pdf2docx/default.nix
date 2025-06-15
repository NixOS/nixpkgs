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
  opencv-python-headless,
  tkinter,
  python-docx,
  setuptools,
}:
let
  version = "0.5.8";
in
buildPythonPackage {
  pname = "pdf2docx";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ArtifexSoftware";
    repo = "pdf2docx";
    tag = "v${version}";
    hash = "sha256-tMITDm2NkxWS+H/hhd2LlaPbyuI86ZKaALqqHJqb8V0=";
  };

  build-system = [
    pip
    setuptools
  ];

  preBuild = "echo '${version}' > version.txt";

  dependencies = [
    pymupdf
    fire
    fonttools
    numpy
    opencv-python-headless
    python-docx
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlags = [
    "-v"
  ];

  enabledTestPaths = [
    "./test/test.py::TestConversion"
  ];
  # Test fails due to "RuntimeError: cannot find builtin font with name 'Arial'":
  disabledTests = [ "test_unnamed_fonts" ];

  meta = with lib; {
    description = "Convert PDF to DOCX";
    mainProgram = "pdf2docx";
    homepage = "https://github.com/ArtifexSoftware/pdf2docx";
    changelog = "https://github.com/ArtifexSoftware/pdf2docx/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ happysalada ];
  };
}
