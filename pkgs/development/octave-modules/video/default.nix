{
  buildOctavePackage,
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  ffmpeg,
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
    ffmpeg
  ];

  meta = {
    homepage = "https://octave.sourceforge.io/video/index.html";
    license = with lib.licenses; [
      gpl3Plus
      bsd3
    ];
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Wrapper for OpenCV's CvCapture_FFMPEG and CvVideoWriter_FFMPEG";
  };
}
