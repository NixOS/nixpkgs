{
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  fetchurl,
  ffmpeg_7-headless,
  lib,
  linkFarm,
  numpy,
  pillow,
  pkg-config,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "av";
  version = "13.1.0"; # nixpkgs-update: no auto update
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyAV-Org";
    repo = "PyAV";
    tag = "v${version}";
    hash = "sha256-x2a9SC4uRplC6p0cD7fZcepFpRidbr6JJEEOaGSWl60=";
  };

  build-system = [
    cython
    setuptools
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ffmpeg_7-headless ];

  preCheck =
    let
      testSamples = linkFarm "pyav-test-samples" (
        lib.mapAttrs (_: fetchurl) (lib.importTOML ../av/test-samples.toml)
      );
    in
    ''
      # ensure we import the built version
      rm -r av
      ln -s ${testSamples} tests/assets
    '';

  nativeCheckInputs = [
    numpy
    pillow
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "av"
    "av.audio"
    "av.buffer"
    "av.bytesource"
    "av.codec"
    "av.container"
    "av._core"
    "av.datasets"
    "av.descriptor"
    "av.dictionary"
    "av.error"
    "av.filter"
    "av.format"
    "av.frame"
    "av.logging"
    "av.option"
    "av.packet"
    "av.plane"
    "av.stream"
    "av.subtitles"
    "av.utils"
    "av.video"
  ];

  passthru.skipBulkUpdate = true;

  meta = {
    changelog = "https://github.com/PyAV-Org/PyAV/blob/${src.tag}/CHANGELOG.rst";
    description = "Pythonic bindings for FFmpeg";
    homepage = "https://github.com/PyAV-Org/PyAV";
    license = lib.licenses.bsd2;
    mainProgram = "pyav";
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
