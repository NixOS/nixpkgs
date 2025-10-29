{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  beautifulsoup4,
  defusedxml,
  ffmpeg-headless,
  magika,
  mammoth,
  markdownify,
  numpy,
  openai,
  openpyxl,
  pandas,
  pathvalidate,
  pdfminer-six,
  puremagic,
  pydub,
  python-pptx,
  requests,
  speechrecognition,
  youtube-transcript-api,
  olefile,
  xlrd,
  lxml,
  pytestCheckHook,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "markitdown";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "markitdown";
    tag = "v${version}";
    hash = "sha256-bHnJsv4ln1W0lVbWwLmCzQ15KOGJZ9gF2yx4TDuBqBI=";
  };

  sourceRoot = "${src.name}/packages/markitdown";

  build-system = [ hatchling ];

  dependencies = [
    beautifulsoup4
    defusedxml
    ffmpeg-headless
    lxml
    magika
    mammoth
    markdownify
    numpy
    olefile
    openai
    openpyxl
    pandas
    pathvalidate
    pdfminer-six
    puremagic
    pydub
    python-pptx
    requests
    speechrecognition
    xlrd
    youtube-transcript-api
  ];

  pythonImportsCheck = [ "markitdown" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Require network access
    "test_markitdown_remote"
    "test_module_vectors"
    "test_cli_vectors"
    "test_module_misc"
  ];

  passthru.updateScripts = gitUpdater { };

  meta = {
    description = "Python tool for converting files and office documents to Markdown";
    homepage = "https://github.com/microsoft/markitdown";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
