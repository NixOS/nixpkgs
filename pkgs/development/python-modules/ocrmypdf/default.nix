{
  lib,
  buildPythonPackage,
  deprecation,
  fetchFromGitHub,
  ghostscript,
  hypothesis,
  img2pdf,
  jbig2enc,
  packaging,
  pdfminer-six,
  pillow-heif,
  pikepdf,
  pillow,
  pluggy,
  pngquant,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  rich,
  reportlab,
  setuptools-scm,
  substituteAll,
  tesseract,
  unpaper,
  installShellFiles,
}:

buildPythonPackage rec {
  pname = "ocrmypdf";
  version = "16.4.3";

  disabled = pythonOlder "3.10";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "ocrmypdf";
    repo = "OCRmyPDF";
    rev = "v${version}";
    # The content of .git_archival.txt is substituted upon tarball creation,
    # which creates indeterminism if master no longer points to the tag.
    # See https://github.com/ocrmypdf/OCRmyPDF/issues/841
    postFetch = ''
      rm "$out/.git_archival.txt"
    '';
    hash = "sha256-SHinfAWUqrPnHdDDXa1meVfxsyct17b1ak5U91GEc1w=";
  };

  patches = [
    ./use-pillow-heif.patch
    (substituteAll {
      src = ./paths.patch;
      gs = lib.getExe ghostscript;
      jbig2 = lib.getExe jbig2enc;
      pngquant = lib.getExe pngquant;
      tesseract = lib.getExe tesseract;
      unpaper = lib.getExe unpaper;
    })
  ];

  build-system = [ setuptools-scm ];

  nativeBuildInputs = [ installShellFiles ];

  dependencies = [
    deprecation
    img2pdf
    packaging
    pdfminer-six
    pillow-heif
    pikepdf
    pillow
    pluggy
    rich
  ];

  nativeCheckInputs = [
    hypothesis
    pytest-xdist
    pytestCheckHook
    reportlab
  ];

  pythonImportsCheck = [ "ocrmypdf" ];

  postInstall = ''
    installShellCompletion --cmd ocrmypdf \
      --bash misc/completion/ocrmypdf.bash \
      --fish misc/completion/ocrmypdf.fish
  '';

  meta = with lib; {
    homepage = "https://github.com/ocrmypdf/OCRmyPDF";
    description = "Adds an OCR text layer to scanned PDF files, allowing them to be searched";
    license = with licenses; [
      mpl20
      mit
    ];
    maintainers = with maintainers; [
      dotlambda
    ];
    changelog = "https://github.com/ocrmypdf/OCRmyPDF/blob/${src.rev}/docs/release_notes.rst";
    mainProgram = "ocrmypdf";
  };
}
