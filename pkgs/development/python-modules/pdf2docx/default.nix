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
  version = "0.5.9";
in
buildPythonPackage {
  pname = "pdf2docx";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ArtifexSoftware";
    repo = "pdf2docx";
    tag = "v${version}";
    hash = "sha256-yfxBWQ8r0mCZkk7Gtbeub5x9HBpNWXv6kW1D678hN4g=";
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

  meta = {
    description = "Convert PDF to DOCX";
    mainProgram = "pdf2docx";
    homepage = "https://github.com/ArtifexSoftware/pdf2docx";
    changelog = "https://github.com/ArtifexSoftware/pdf2docx/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
