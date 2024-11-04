{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonRelaxDepsHook,
  pytestCheckHook,
  poetry-core,
  poetry-dynamic-versioning,
  blackrenderer,
  fonttools,
  freetype-py,
  gflanguages,
  glyphsets,
  jinja2,
  ninja,
  pillow,
  protobuf,
  pyahocorasick,
  python-bidi,
  selenium,
  tqdm,
  uharfbuzz,
  unicodedata2,
  youseedee,
  numpy,
}:

buildPythonPackage rec {
  pname = "diffenator2";
  version = "0.4.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "diffenator2";
    rev = "refs/tags/v${version}";
    hash = "sha256-Iu6ZA8s6XnOYSOwlt8WTmYW6oUTvcm4vLhYvVATOlBA=";
  };

  env.PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";

  pythonRelaxDeps = [
    "protobuf"
    "python-bidi"
    "youseedee"
  ];

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    blackrenderer
    fonttools
    freetype-py
    gflanguages
    glyphsets
    jinja2
    ninja
    pillow
    protobuf
    pyahocorasick
    python-bidi
    selenium
    tqdm
    uharfbuzz
    unicodedata2
    youseedee
    numpy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # requires internet
    "test_download_google_fonts_family_to_file"
    "test_download_google_fonts_family_to_bytes"
    "test_download_google_fonts_family_not_existing"
    "test_download_latest_github_release"
  ];

  disabledTestPaths = [
    # Want the files downloaded by the tests above
    "tests/test_functional.py"
    "tests/test_html.py"
    "tests/test_matcher.py"
    "tests/test_font.py"
  ];

  meta = {
    description = "Font comparison tool that will not stop until your fonts are exhaustively compared";
    homepage = "https://github.com/googlefonts/diffenator2";
    changelog = "https://github.com/googlefonts/diffenator2/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "diffenator2";
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
