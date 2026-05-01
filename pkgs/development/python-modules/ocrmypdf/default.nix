{
  lib,
  buildPythonPackage,
  deprecation,
  fetchFromGitHub,
  ghostscript_headless,
  hatch-vcs,
  hatchling,
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
  rich,
  reportlab,
  replaceVars,
  tesseract,
  unpaper,
  installShellFiles,
}:

buildPythonPackage rec {
  pname = "ocrmypdf";
  version = "16.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ocrmypdf";
    repo = "OCRmyPDF";
    tag = "v${version}";
    # The content of .git_archival.txt is substituted upon tarball creation,
    # which creates indeterminism if master no longer points to the tag.
    # See https://github.com/ocrmypdf/OCRmyPDF/issues/841
    postFetch = ''
      rm "$out/.git_archival.txt"
    '';
    hash = "sha256-1KaSUitQG/c49s7X17+4x29lRM9mvA8F1EX/2I7dE0E=";
  };

  patches = [
    ./use-pillow-heif.patch
    (replaceVars ./paths.patch {
      gs = lib.getExe ghostscript_headless;
      jbig2 = lib.getExe jbig2enc;
      pngquant = lib.getExe pngquant;
      tesseract = lib.getExe tesseract;
      unpaper = lib.getExe unpaper;
    })
  ];

  build-system = [
    hatch-vcs
    hatchling
  ];

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

  meta = {
    homepage = "https://github.com/ocrmypdf/OCRmyPDF";
    description = "Adds an OCR text layer to scanned PDF files, allowing them to be searched";
    license = with lib.licenses; [
      mpl20
      mit
    ];
    maintainers = with lib.maintainers; [
      dotlambda
    ];
    changelog = "https://github.com/ocrmypdf/OCRmyPDF/blob/${src.tag}/docs/release_notes.md";
    mainProgram = "ocrmypdf";
  };
}
