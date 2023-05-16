{ lib
, buildPythonPackage
<<<<<<< HEAD
, deprecation
, fetchFromGitHub
, ghostscript
, hypothesis
=======
, coloredlogs
, deprecation
, fetchFromGitHub
, ghostscript
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
, rich
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "14.4.0";
=======
  version = "14.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    hash = "sha256-i1ZUBKR8dJXZkALUFwkzYcjtZ5Li66DfD2fupCGRQC4=";
=======
    hash = "sha256-Jyx9FPXNjcA04s+l2wY/LVX83RqExt78/EAHsL1VNMU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
    coloredlogs
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    deprecation
    img2pdf
    packaging
    pdfminer-six
    pikepdf
    pillow
    pluggy
    reportlab
<<<<<<< HEAD
    rich
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    tqdm
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  nativeCheckInputs = [
<<<<<<< HEAD
    hypothesis
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
