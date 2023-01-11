{ lib
, buildPythonPackage
, coloredlogs
, deprecation
, fetchFromGitHub
, ghostscript
, img2pdf
, importlib-resources
, jbig2enc
, packaging
, pdfminer-six
, pikepdf
, pillow
, pluggy
, pngquant
, pytest-xdist
, pytestCheckHook
, pythonOlder
, reportlab
, setuptools
, setuptools-scm
, substituteAll
, tesseract
, tqdm
, typing-extensions
, unpaper
, installShellFiles
}:

buildPythonPackage rec {
  pname = "ocrmypdf";
  version = "14.0.2";

  disabled = pythonOlder "3.8";

  format = "pyproject";

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
    hash = "sha256-s2G+ZNMEF3ZB1+ibPiYPuqdypoYFdFPpASeqFReR8/g=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  patches = [
    (substituteAll {
      src = ./paths.patch;
      gs = "${lib.getBin ghostscript}/bin/gs";
      jbig2 = "${lib.getBin jbig2enc}/bin/jbig2";
      pngquant = "${lib.getBin pngquant}/bin/pngquant";
      tesseract = "${lib.getBin tesseract}/bin/tesseract";
      unpaper = "${lib.getBin unpaper}/bin/unpaper";
    })
  ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    installShellFiles
  ];

  propagatedBuildInputs = [
    coloredlogs
    deprecation
    img2pdf
    packaging
    pdfminer-six
    pikepdf
    pillow
    pluggy
    reportlab
    tqdm
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  checkInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ocrmypdf"
  ];

  postInstall = ''
    installShellCompletion --cmd ocrmypdf \
      --bash misc/completion/ocrmypdf.bash \
      --fish misc/completion/ocrmypdf.fish
  '';

  meta = with lib; {
    homepage = "https://github.com/ocrmypdf/OCRmyPDF";
    description = "Adds an OCR text layer to scanned PDF files, allowing them to be searched";
    license = with licenses; [ mpl20 mit ];
    maintainers = with maintainers; [ kiwi dotlambda ];
    changelog = "https://github.com/ocrmypdf/OCRmyPDF/blob/${src.rev}/docs/release_notes.rst";
  };
}
