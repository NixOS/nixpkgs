{
  buildOctavePackage,
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  ffmpeg_4,
}:

buildOctavePackage rec {
  pname = "video";
  version = "2.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-bZNaRnmJl5UF0bQMNoEWvoIXJaB0E6/V9eChE725OHY=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  propagatedBuildInputs = [
    ffmpeg_4
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/video/index.html";
    license = with licenses; [
      gpl3Plus
      bsd3
    ];
    maintainers = with maintainers; [ KarlJoad ];
    description = "Wrapper for OpenCV's CvCapture_FFMPEG and CvVideoWriter_FFMPEG";
    # error: declaration of 'panic' has a different language linkage
    broken = stdenv.isDarwin;
  };
}
