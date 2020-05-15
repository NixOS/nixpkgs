{ lib
, buildPythonPackage
, fetchFromGitHub
, substituteAll
, ffmpeg
, future
, pytest
, pytestrunner
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
    (
      substituteAll {
        src = ./ffmpeg-location.patch;
        inherit ffmpeg;
      }
    )
  ];

  buildInputs = [ pytestrunner ];
  propagatedBuildInputs = [ future ];
  checkInputs = [ pytest pytest-mock ];

  meta = with lib; {
    description = "Python bindings for FFmpeg - with complex filtering support";
    homepage = "https://github.com/kkroening/ffmpeg-python";
    license = licenses.asl20;
    maintainers = [ maintainers.AluisioASG ];
    platforms = platforms.all;
  };
}
