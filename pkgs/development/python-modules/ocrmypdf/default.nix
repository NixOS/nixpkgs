{
  lib,
  buildPythonPackage,
  cyclopts,
  fetchFromGitHub,
  fpdf2,
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
  pydantic,
  pypdfium2,
  pytest-xdist,
  pytestCheckHook,
  python-dotenv,
  rich,
  reportlab,
  replaceVars,
  streamlit,
  tesseract,
  uharfbuzz,
  unpaper,
  watchfiles,
  xpdf,
  installShellFiles,
}:

buildPythonPackage (finalAttrs: {
  pname = "ocrmypdf";
  version = "17.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ocrmypdf";
    repo = "OCRmyPDF";
    tag = "v${finalAttrs.version}";
    # The content of .git_archival.txt is substituted upon tarball creation,
    # which creates indeterminism if master no longer points to the tag.
    # See https://github.com/ocrmypdf/OCRmyPDF/issues/841
    postFetch = ''
      rm "$out/.git_archival.txt"
    '';
    hash = "sha256-4gjA33EEY9v+dmXh2yMthnE9x8lJ+wU1ZVBN5fnoqdA=";
  };

  patches = [
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
    fpdf2
    img2pdf
    packaging
    pdfminer-six
    pikepdf
    pillow
    pluggy
    pydantic
    pypdfium2
    rich
    uharfbuzz
  ]
  ++ pikepdf.optional-dependencies.pdfa;

  optional-dependencies = {
    heic = [ pillow-heif ];
    watcher = [
      cyclopts
      python-dotenv
      watchfiles
    ];
    webservice = [ streamlit ];
  };

  nativeCheckInputs = [
    hypothesis
    pytest-xdist
    pytestCheckHook
    reportlab
    xpdf # for pdftotext
  ];

  disabledTests = [
    # tests set TZ=America/Los_Angeles but that doesn't seem to have an effect
    "test_unzoned_creation_date_assumes_local_zone"
    "test_assume_local_time_zone"
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
    changelog = "https://github.com/ocrmypdf/OCRmyPDF/blob/${finalAttrs.src.tag}/docs/releasenotes/version17.md";
    mainProgram = "ocrmypdf";
  };
})
