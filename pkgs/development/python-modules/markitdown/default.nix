{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  beautifulsoup4,
  ffmpeg-headless,
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
  pytestCheckHook,
  gitUpdater,
}:

buildPythonPackage {
  pname = "markitdown";
  version = "unstable-2024-12-18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "markitdown";
    rev = "3ce21a47abed0e4db162de1088d661887ae076ff";
    hash = "sha256-5YafFL8OHNcGgB/qH6CmX0rTith1ZSRNIa+ktl4Ffvg=";
  };

  build-system = [ hatchling ];

  dependencies = [
    beautifulsoup4
    ffmpeg-headless
    mammoth
    markdownify
    numpy
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
    youtube-transcript-api
  ];

  pythonImportsCheck = [ "markitdown" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Require network access
    "test_markitdown_remote"
  ];

  passthru.updateScripts = gitUpdater { };

  meta = {
    description = "Python tool for converting files and office documents to Markdown";
    homepage = "https://github.com/microsoft/markitdown";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
