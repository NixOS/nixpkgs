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

buildPythonPackage (finalAttrs: {
  pname = "knowit";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ratoaq2";
    repo = "knowit";
    tag = finalAttrs.version;
    hash = "sha256-krrAeroM1eQZXi2onV4FdrKIQdPLkZS+/ypyY0Kc+Pw=";
  };

  matroska_test_zip = fetchzip {
    url = "http://downloads.sourceforge.net/project/matroska/test_files/matroska_test_w1_1.zip";
    hash = "sha256-X8gIfDj2iP043kjO3yqxuIgn8mZMX7XaqzhQ7CTLUhc=";
    stripRoot = false;
  };

  postPatch = ''
    mkdir -p tests/data/videos
    cp ${finalAttrs.matroska_test_zip}/*.mkv tests/data/videos/
  '';

  build-system = [ poetry-core ];

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

  nativeCheckInputs = [
    pytestCheckHook
    ffmpeg
    mediainfo
    mkvtoolnix
    requests
  ];

  pythonImportsCheck = [ "knowit" ];

  meta = {
    description = "Extract metadata from media files";
    homepage = "https://github.com/ratoaq2/knowit";
    changelog = "https://github.com/ratoaq2/knowit/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iynaix ];
    mainProgram = "knowit";
  };
})
