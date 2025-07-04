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
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "Andy1978";
    repo = "octave-video";
    rev = "refs/tags/${version}";
    hash = "sha256-fn9LNfuS9dSStBfzBjRRkvP50JJ5K+Em02J9+cHqt6w=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  propagatedBuildInputs = [
    ffmpeg
  ];

  meta = {
    homepage = "https://gnu-octave.github.io/packages/video/";
    license = with lib.licenses; [
      gpl3Plus
      bsd3
    ];
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Wrapper for OpenCV's CvCapture_FFMPEG and CvVideoWriter_FFMPEG";
  };
}
