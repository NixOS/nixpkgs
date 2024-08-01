{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  pytestCheckHook,
  go,
  ffmpeg-headless,
}:

buildPythonPackage rec {
  pname = "ffmpy";
  version = "0.3.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Ch00k";
    repo = "ffmpy";
    rev = "refs/tags/${version}";
    hash = "sha256-q41JjAWcIiD2nJck5Zzb/lhfIZ3xJGU1I2crsMN0T8Q=";
  };

  postPatch = ''
    # default to store ffmpeg
    substituteInPlace ffmpy.py \
      --replace-fail 'executable="ffmpeg",' 'executable="${ffmpeg-headless}/bin/ffmpeg",'

    #  The tests test a mock that does not behave like ffmpeg. If we default to the nix-store ffmpeg they fail.
    for fname in tests/*.py; do
      echo 'FFmpeg.__init__.__defaults__ = ("ffmpeg", *FFmpeg.__init__.__defaults__[1:])' >>"$fname"
    done
  '';

  pythonImportsCheck = [ "ffmpy" ];

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    go
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    # expects a FFExecutableNotFoundError, gets a NotADirectoryError raised by os
    "test_invalid_executable_path"
  ];

  # the vendored ffmpeg mock binary assumes FHS
  preCheck = ''
    rm -v tests/ffmpeg/ffmpeg
    HOME=$(mktemp -d) go build -o ffmpeg tests/ffmpeg/ffmpeg.go
    export PATH=".:$PATH"
  '';

  meta = with lib; {
    description = "Simple python interface for FFmpeg/FFprobe";
    homepage = "https://github.com/Ch00k/ffmpy";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
