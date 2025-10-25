{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  pytestCheckHook,
  go,
  ffmpeg-headless,
}:

buildPythonPackage rec {
  pname = "ffmpy";
  version = "0.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Ch00k";
    repo = "ffmpy";
    tag = version;
    hash = "sha256-wtblSJOkSIR03q7uKNAS7d0F0Wo7QRlYnwIhmZoPeZo=";
  };

  postPatch =
    # Default to store ffmpeg.
    ''
      substituteInPlace ffmpy/ffmpy.py \
        --replace-fail \
          'executable: str = "ffmpeg",' \
          'executable: str = "${lib.getExe ffmpeg-headless}",'
    ''
    # The tests test a mock that does not behave like ffmpeg. If we default to the nix-store ffmpeg they fail.
    + ''
      for fname in tests/*.py; do
        echo >>"$fname" 'FFmpeg.__init__.__defaults__ = ("ffmpeg", *FFmpeg.__init__.__defaults__[1:])'
      done
    '';

  pythonImportsCheck = [ "ffmpy" ];

  build-system = [ uv-build ];

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

  meta = {
    description = "Simple python interface for FFmpeg/FFprobe";
    homepage = "https://github.com/Ch00k/ffmpy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbsds ];
  };
}
