{ buildOctavePackage
, stdenv
, lib
, fetchFromGitHub
, pkg-config
, ffmpeg_7
}:

buildOctavePackage rec {
  pname = "video";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "Andy1978";
    repo = "octave-video";
    rev = version;
    hash = "sha256-JFySAu/3lCnfuFMNGYPzX2MqhsRi1+IyJQBcKB9vCo0=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  propagatedBuildInputs = [
    ffmpeg_7
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/video/index.html";
    license = with licenses; [ gpl3Plus bsd3 ];
    maintainers = with maintainers; [ KarlJoad ];
    description = "Wrapper for OpenCV's CvCapture_FFMPEG and CvVideoWriter_FFMPEG";
  };
}
