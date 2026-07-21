{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ffmpeg-headless,
  setuptools,
  pyee,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "python-ffmpeg";
  version = "2.0.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jonghwanhyeon";
    repo = "python-ffmpeg";
    tag = "v${version}";
    hash = "sha256-1dhkjrg7QUtYSyEV9c88HphdcFuSCSaGJqVAQmMF/5E=";
  };

  postPatch = ''
    substituteInPlace ffmpeg/{ffmpeg.py,asyncio/ffmpeg.py,protocol.py} \
      --replace-fail 'executable: str = "ffmpeg"' 'executable: str = "${lib.getExe ffmpeg-headless}"'
    substituteInPlace tests/helpers.py \
      --replace-fail '"ffprobe"' '"${lib.getExe' ffmpeg-headless "ffprobe"}"'

    # Some systems can finish before the `0.1` timeout.
    substituteInPlace tests/test_{,asyncio_}timeout.py \
      --replace-fail 'ffmpeg.execute(timeout=0.1)' 'ffmpeg.execute(timeout=0.01)'
  '';

  build-system = [ setuptools ];

  dependencies = [ pyee ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "ffmpeg" ];

  meta = {
    homepage = "https://github.com/jonghwanhyeon/python-ffmpeg";
    description = "Python binding for FFmpeg which provides sync and async APIs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ youhaveme9 ];
  };
}
