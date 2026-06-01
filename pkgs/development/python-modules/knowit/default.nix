{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchzip,

  # build-system
  poetry-core,

  # dependencies
  babelfish,
  enzyme,
  pymediainfo,
  pyyaml,
  trakit,
  pint,

  # nativeCheckInputs
  pytestCheckHook,
  ffmpeg,
  mediainfo,
  mkvtoolnix,
  requests,
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

  matroska_test_zip = fetchzip {
    url = "http://downloads.sourceforge.net/project/matroska/test_files/matroska_test_w1_1.zip";
    hash = "sha256-X8gIfDj2iP043kjO3yqxuIgn8mZMX7XaqzhQ7CTLUhc=";
    stripRoot = false;
  };

  postPatch = ''
    mkdir -p tests/data/videos
    cp ${matroska_test_zip}/*.mkv tests/data/videos/
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
    requests
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
