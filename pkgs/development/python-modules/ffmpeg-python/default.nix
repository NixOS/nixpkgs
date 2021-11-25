{ lib
, buildPythonPackage
, fetchFromGitHub
, substituteAll
, pytestCheckHook
, ffmpeg
, future
, pytest-runner
, pytest-mock
}:

buildPythonPackage rec {
  pname = "ffmpeg-python";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "kkroening";
    repo = "ffmpeg-python";
    rev = version;
    sha256 = "0mmydmfz3yiclbgi4lqrv9fh2nalafg4bkm92y2qi50mwqgffk8f";
  };

  patches = [
    (substituteAll {
      src = ./ffmpeg-location.patch;
      inherit ffmpeg;
    })
  ];

  buildInputs = [ pytest-runner ];
  propagatedBuildInputs = [ future ];
  checkInputs = [ pytestCheckHook pytest-mock ];

  meta = with lib; {
    description = "Python bindings for FFmpeg - with complex filtering support";
    homepage = "https://github.com/kkroening/ffmpeg-python";
    license = licenses.asl20;
    maintainers = [ maintainers.AluisioASG ];
  };
}
