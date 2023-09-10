{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, go
, ffmpeg-headless
}:

buildPythonPackage rec {
  pname = "ffmpy";
  version = "0.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Ch00k";
    repo = "ffmpy";
    rev = "refs/tags/${version}";
    hash = "sha256-kuLhmCG80BmXdqpW67UanBnuYiL2Oh1jKt7IgmVNEAM=";
  };

  postPatch = ''
    # default to store ffmpeg
    substituteInPlace ffmpy.py \
      --replace 'executable="ffmpeg",' 'executable="${ffmpeg-headless}/bin/ffmpeg",'

    #  The tests test a mock that does not behave like ffmpeg. If we default to the nix-store ffmpeg they fail.
    for fname in tests/*.py; do
      echo 'FFmpeg.__init__.__defaults__ = ("ffmpeg", *FFmpeg.__init__.__defaults__[1:])' >>"$fname"
    done
  '';

  pythonImportsCheck = [ "ffmpy" ];

  nativeCheckInputs = [
    pytestCheckHook
    go
  ];

  # the vendored ffmpeg mock binary assumes FHS
  preCheck = ''
    rm -v tests/ffmpeg/ffmpeg
    HOME=$(mktemp -d) go build -o ffmpeg tests/ffmpeg/ffmpeg.go
    export PATH=".:$PATH"
  '';

  meta = with lib; {
    description = "A simple python interface for FFmpeg/FFprobe";
    homepage = "https://github.com/Ch00k/ffmpy";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
