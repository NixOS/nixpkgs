{ buildOctavePackage
, stdenv
, lib
, fetchurl
, pkg-config
, ffmpeg
}:

buildOctavePackage rec {
  pname = "video";
  version = "2.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0s6j3c4dh5nsbh84s7vnd2ajcayy1gn07b4fcyrcynch3wl28mrv";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  propagatedBuildInputs = [
    ffmpeg
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/video/index.html";
    license = with licenses; [ gpl3Plus bsd3 ];
    maintainers = with maintainers; [ KarlJoad ];
    description = "Wrapper for OpenCV's CvCapture_FFMPEG and CvVideoWriter_FFMPEG";
    # error: declaration of 'panic' has a different language linkage
    broken = stdenv.isDarwin;
  };
}
