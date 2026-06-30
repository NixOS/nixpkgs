{
  lib,
  fetchFromGitHub,
  fetchPypi,
  python3,
  antiword,
  ghostscript,
  poppler-utils,
  sox,
  tesseract,
  unrtf,
  versionCheckHook,
  nix-update-script,
}:

let
  #textract's xlsx parser uses xlrd.open_workbook() which requires
  #xlrd < 2.0.0 because xlrd 2.x removed .xlsx support
  #
  #Upstream issue:
  #https://github.com/deanmalmgren/textract/pull/543#issuecomment-2684619988

  xlrd1 = python3.pkgs.buildPythonPackage (finalAttrs: {
    pname = "xlrd";
    version = "1.2.0";

    pyproject = true;

    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-VG6zbO6NtAw+qkbDUeZ//ubutfomULcbxMdYopobKbI=";
    };

    build-system = with python3.pkgs; [ setuptools ];

    pythonImportsCheck = [ "xlrd" ];

    meta = {
      description = "Library for reading data and formatting information from Excel files";
      homepage = "https://xlrd.readthedocs.io/";
      license = with lib.licenses; [
        bsd3
        bsdOriginal
      ];
    };
  });
in

python3.pkgs.buildPythonPackage (finalAttrs: {
  pname = "textract";
  version = "2.0.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "deanmalmgren";
    repo = "textract";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MZfK3eVYgrb2yoxzkzS4MqWE4vo6NAv+qQrldhn13C4=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  build-system = with python3.pkgs; [ uv-build ];

  dependencies = with python3.pkgs; [
    argcomplete
    beautifulsoup4
    chardet
    docx2txt
    extract-msg
    lxml
    pdfminer-six
    pillow
    pocketsphinx
    python-pptx
    speechrecognition
    xlrd1
  ];

  nativeCheckInputs =
    with python3.pkgs;
    [
      pytestCheckHook
    ]
    ++ [
      antiword
      ghostscript
      poppler-utils
      sox
      tesseract
      unrtf
    ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  #Skip test that require network access
  preCheck = ''
    export SKIP_NETWORK_TESTS=true

    export PATH="$out/bin:${
      lib.makeBinPath [
        antiword
        ghostscript
        poppler-utils
        sox
        tesseract
        unrtf
      ]
    }:$PATH"
  '';

  disabledTestPaths = [
    #Tesseract OCR output varies by version
    "tests/test_jpg.py"
    "tests/test_png.py"
    "tests/test_tiff.py"
  ];

  disabledTests = [
    #Skip tests requiring network access
    "test_mp3"
    "test_mp3_google"

    #Google Speech recognition output has changed over time
    #instead of "Everything is Awesome", causing these strict
    #comparison to fail
    "test_raw_text_cli"
    "test_raw_text_python"
    "test_filename_spaces"
    "test_standardized_text_cli"
    "test_standardized_text_python"
  ];

  pythonImportsCheck = [
    "textract"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Extract text from any document";
    homepage = "https://textract.readthedocs.io/";
    downloadPage = "https://github.com/deanmalmgren/textract";
    changelog = "https://github.com/deanmalmgren/textract/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
