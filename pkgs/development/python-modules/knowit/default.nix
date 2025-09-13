{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,
  poetry-core,
  babelfish,
  enzyme,
  pymediainfo,
  pyyaml,
  trakit,
  pint,

  # check inputs
  pytestCheckHook,
  ffmpeg,
  mediainfo,
  mkvtoolnix,
}:

buildPythonPackage rec {
  pname = "knowit";
  version = "0.5.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ratoaq2";
    repo = "knowit";
    tag = version;
    hash = "sha256-JqzCLdXEWZyvqXpeTJRW0zhY+wVcHLuBYrJbuSqfgkg=";
  };

  matroska_test_zip = fetchurl {
    url = "http://downloads.sourceforge.net/project/matroska/test_files/matroska_test_w1_1.zip";
    hash = "sha256-2G+W4WXmlebPUyTryhhPLfcjhy8ClltWWCDSZbUwBOs=";
  };

  # use a local copy of the matroska test file for the tests
  patches = [ ./matroska_tests.patch ];

  postPatch = ''
    substituteInPlace tests/__init__.py \
      --subst-var-by matroskaTestFile "${matroska_test_zip}"
  '';

  build-system = [
    poetry-core
  ];

  dependencies = [
    babelfish
    enzyme
    pymediainfo
    pyyaml
    trakit
  ];

  optional-dependencies = {
    pint = [
      pint
    ];
  };

  pythonImportsCheck = [
    "knowit"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    ffmpeg
    mediainfo
    mkvtoolnix
  ];

  meta = {
    changelog = "https://github.com/ratoaq2/knowit/releases/tag/${src.tag}";
    description = "Extract metadata from media files";
    homepage = "https://github.com/ratoaq2/knowit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iynaix ];
    mainProgram = "knowit";
  };
}
