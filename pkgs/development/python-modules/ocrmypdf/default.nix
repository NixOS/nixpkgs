{ lib
, buildPythonPackage
, coloredlogs
, fetchFromGitHub
, ghostscript
, img2pdf
, importlib-metadata
, importlib-resources
, jbig2enc
, pdfminer
, pikepdf
, pillow
, pluggy
, pngquant
, pytest-xdist
, pytestCheckHook
, pythonOlder
, reportlab
, setuptools-scm
, setuptools-scm-git-archive
, stdenv
, substituteAll
, tesseract4
, tqdm
, unpaper
}:

buildPythonPackage rec {
  pname = "ocrmypdf";
  version = "13.3.0";

  src = fetchFromGitHub {
    owner = "jbarlow83";
    repo = "OCRmyPDF";
    rev = "v${version}";
    # The content of .git_archival.txt is substituted upon tarball creation,
    # which creates indeterminism if master no longer points to the tag.
    # See https://github.com/jbarlow83/OCRmyPDF/issues/841
    extraPostFetch = ''
      rm "$out/.git_archival.txt"
    '';
    sha256 = "sha256-8QOxHka2kl/keYbsP1zOZ8hrZ+15ZGJaw91F+cpWvcA=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  patches = [
    (substituteAll {
      src = ./paths.patch;
      gs = "${lib.getBin ghostscript}/bin/gs";
      jbig2 = "${lib.getBin jbig2enc}/bin/jbig2";
      pngquant = "${lib.getBin pngquant}/bin/pngquant";
      tesseract = "${lib.getBin tesseract4}/bin/tesseract";
      unpaper = "${lib.getBin unpaper}/bin/unpaper";
    })
  ];

  nativeBuildInputs = [
    setuptools-scm-git-archive
    setuptools-scm
  ];

  propagatedBuildInputs = [
    coloredlogs
    img2pdf
    pdfminer
    pikepdf
    pillow
    pluggy
    reportlab
    tqdm
  ] ++ (lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ]) ++ (lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ]);

  checkInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ocrmypdf"
  ];

  meta = with lib; {
    homepage = "https://github.com/jbarlow83/OCRmyPDF";
    description = "Adds an OCR text layer to scanned PDF files, allowing them to be searched";
    license = with licenses; [ mpl20 mit ];
    maintainers = with maintainers; [ kiwi dotlambda ];
    changelog = "https://github.com/jbarlow83/OCRmyPDF/blob/v${version}/docs/release_notes.rst";
  };
}
