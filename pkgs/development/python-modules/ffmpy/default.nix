{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  uv-build,
  pytestCheckHook,
  go,
  ffmpeg-headless,
}:

buildPythonPackage rec {
  pname = "ffmpy";
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8.1";

  src = fetchFromGitHub {
    owner = "Ch00k";
    repo = "ffmpy";
    tag = version;
    hash = "sha256-U20mBg+428kkka6NY9qc7X8jH8A5bKa++g2+PTn/MYg=";
  };

  postPatch = ''
    # default to store ffmpeg
    substituteInPlace ffmpy/ffmpy.py \
      --replace-fail \
        'executable: str = "ffmpeg",' \
        'executable: str = "${ffmpeg-headless}/bin/ffmpeg",'

    #  The tests test a mock that does not behave like ffmpeg. If we default to the nix-store ffmpeg they fail.
    for fname in tests/*.py; do
      echo >>"$fname" 'FFmpeg.__init__.__defaults__ = ("ffmpeg", *FFmpeg.__init__.__defaults__[1:])'
    done
  '';

  pythonImportsCheck = [ "ffmpy" ];

  nativeBuildInputs = [ uv-build ];

  nativeCheckInputs = [
    pytestCheckHook
    go
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # expects a FFExecutableNotFoundError, gets a NotADirectoryError raised by os
    "test_invalid_executable_path"
  ];

  # the vendored ffmpeg mock binary assumes FHS
  preCheck = ''
    rm -v tests/ffmpeg/ffmpeg
    echo Building tests/ffmpeg/ffmpeg...
    HOME=$(mktemp -d) go build -o tests/ffmpeg/ffmpeg tests/ffmpeg/ffmpeg.go
  '';

  meta = with lib; {
    description = "Simple python interface for FFmpeg/FFprobe";
    homepage = "https://github.com/Ch00k/ffmpy";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
