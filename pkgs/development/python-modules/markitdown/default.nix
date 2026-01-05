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
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "markitdown";
    tag = "v${version}";
    hash = "sha256-WKA2eY8wY3SM9xZ7Cek5eUcJbO5q6eMDx2aTKfQnFvE=";
  };

  sourceRoot = "${src.name}/packages/markitdown";

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "magika"
  ];
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
    changelog = "https://github.com/microsoft/markitdown/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
