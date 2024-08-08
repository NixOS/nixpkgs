{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonRelaxDepsHook,
  pytestCheckHook,
  gitUpdater,
  poetry-core,
  poetry-dynamic-versioning,
  fonttools,
  jinja2,
  pillow,
  glyphsets,
  uharfbuzz,
  pyahocorasick,
  selenium,
  ninja,
  protobuf,
  gflanguages,
  freetype-py,
  blackrenderer,
  unicodedata2,
  tqdm,
  youseedee,
  python-bidi,
}:

buildPythonPackage rec {
  pname = "diffenator2";
  version = "0.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "diffenator2";
    rev = "v${version}";
    hash = "sha256-zeNcNR14ieY6Inp4kOwIPXd6S+/wFdMFp6wbiqgB/iA=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  pythonRelaxDeps = [ "protobuf" ];

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    fonttools
    jinja2
    pillow
    glyphsets
    uharfbuzz
    pyahocorasick
    selenium
    ninja
    protobuf
    gflanguages
    freetype-py
    blackrenderer
    unicodedata2
    tqdm
    youseedee
    python-bidi
  ] ++ blackrenderer.optional-dependencies.skia;

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    "test_download_google_fonts_family_to_file"
    "test_download_google_fonts_family_to_bytes"
    "test_download_google_fonts_family_not_existing"
    "test_download_latest_github_release"
  ];

  disabledTestPaths = [
    "tests/test_functional.py"
    "tests/test_html.py"
    "tests/test_matcher.py"
    "tests/test_font.py"
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Font comparison tool that will not stop until your fonts are exhaustively compared";
    homepage = "https://github.com/googlefonts/diffenator2";
    license = lib.licenses.asl20;
    mainProgram = "diffenator2";
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
