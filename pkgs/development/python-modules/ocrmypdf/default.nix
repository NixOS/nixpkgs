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
  version = "16.11.0";
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
    hash = "sha256-seylNBl29+QxN+3SbgRUdtTo1JwvW1sODpsz7Gwer3E=";
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

  disabledTests = [
    # Broken by Python 3.13.4 change
    # https://github.com/python/cpython/commit/8e923f36596370aedfdfb12251447bface41317a
    # https://github.com/ocrmypdf/OCRmyPDF/blob/9f6e5a48ada5df7006a8c68b84e2aeae61943d8b/src/ocrmypdf/_exec/ghostscript.py#L66
    "TestDuplicateFilter"

    "test_masks"
    "test_content_preservation"
  ];

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
    changelog = "https://github.com/ocrmypdf/OCRmyPDF/blob/${src.rev}/docs/release_notes.md";
    mainProgram = "ocrmypdf";
  };
}
