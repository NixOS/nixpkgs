{ lib
, buildPythonPackage
, deprecation
, fetchFromGitHub
, ghostscript
, hypothesis
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
, rich
, reportlab
, setuptools
, setuptools-scm
, substituteAll
, tesseract
, tqdm
, typing-extensions
, unpaper
, wheel
, installShellFiles
}:

buildPythonPackage rec {
  pname = "ocrmypdf";
  version = "15.0.2";

  disabled = pythonOlder "3.9";

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
    hash = "sha256-DpsNH3djB35WlqDPauCy7Re8pbZLnUE/pPAix4WHPKM=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  patches = [
    (substituteAll {
      src = ./paths.patch;
      gs = lib.getExe ghostscript;
      jbig2 = lib.getExe jbig2enc;
      pngquant = lib.getExe pngquant;
      tesseract = lib.getExe tesseract;
      unpaper = lib.getExe unpaper;
    })
  ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
    installShellFiles
  ];

  propagatedBuildInputs = [
    deprecation
    img2pdf
    packaging
    pdfminer-six
    pikepdf
    pillow
    pluggy
    reportlab
    rich
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  nativeCheckInputs = [
    hypothesis
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
