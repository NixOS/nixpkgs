{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  audioop-lts,
  ffmpeg-full,
  pytestCheckHook,
  setuptools-scm,
  substituteAll,
}:

buildPythonPackage rec {
  pname = "pydub";
  version = "0.25.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jiaaro";
    repo = "pydub";
    tag = "v${version}";
    hash = "sha256-FTEMT47wPXK5i4ZGjTVAhI/NjJio3F2dbBZzYzClU3c=";
  };

  patches = [
    # Fix test assertions, https://github.com/jiaaro/pydub/pull/769
    (fetchpatch {
      name = "fix-assertions.patch";
      url = "https://github.com/jiaaro/pydub/commit/66c1bf7813ae8621a71484fdcdf609734c0d8efd.patch";
      hash = "sha256-3OIzvTgGK3r4/s5y7izHvouB4uJEmjO6cgKvegtTf7A=";
    })
    # Fix paths to ffmpeg, ffplay and ffprobe
    (substituteAll {
      src = ./ffmpeg-fix-path.patch;
      ffmpeg = lib.getExe ffmpeg-full;
      ffplay = lib.getExe' ffmpeg-full "ffplay";
      ffprobe = lib.getExe' ffmpeg-full "ffprobe";
    })
  ];

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    # in-tree re-implementation has a bug in import statement:
    # https://github.com/jiaaro/pydub/issues/815
    # Note: even if import is fixed, there are reports that the in-tree code
    # has additional problems in how it parses audio files. Hence, using the
    # external audioop-lts package instead.
    audioop-lts
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pydub"
    "pydub.audio_segment"
    "pydub.playback"
  ];

  pytestFlagsArray = [ "test/test.py" ];

  meta = {
    description = "Manipulate audio with a simple and easy high level interface";
    homepage = "http://pydub.com";
    changelog = "https://github.com/jiaaro/pydub/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
