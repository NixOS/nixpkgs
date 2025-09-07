{
  lib,
  audioop-lts,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  ffmpeg-full,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  replaceVars,
}:

buildPythonPackage rec {
  pname = "pydub";
  version = "0.25.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

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
    (replaceVars ./ffmpeg-fix-path.patch {
      ffmpeg = lib.getExe ffmpeg-full;
      ffplay = lib.getExe' ffmpeg-full "ffplay";
      ffprobe = lib.getExe' ffmpeg-full "ffprobe";
    })
  ];

  nativeBuildInputs = [ setuptools ];

  dependencies = [ audioop-lts ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pydub"
    "pydub.audio_segment"
    "pydub.playback"
  ];

  enabledTestPaths = [ "test/test.py" ];

  meta = with lib; {
    description = "Manipulate audio with a simple and easy high level interface";
    homepage = "http://pydub.com";
    changelog = "https://github.com/jiaaro/pydub/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
