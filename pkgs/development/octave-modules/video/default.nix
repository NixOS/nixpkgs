{
  buildOctavePackage,
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  autoconf,
  automake,
  ffmpeg_7,
}:

buildOctavePackage rec {
  pname = "video";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "Andy1978";
    repo = "octave-video";
    tag = version;
    hash = "sha256-fn9LNfuS9dSStBfzBjRRkvP50JJ5K+Em02J9+cHqt6w=";
  };

  preBuild = ''
    pushd src
    patchShebangs bootstrap configure
    ./bootstrap
    ./configure
    popd

    tar --transform 's,^,video-${version}/,' -cz * -f video-${version}.tar.gz
  '';

  nativeBuildInputs = [
    pkg-config
    autoconf
    automake
  ];

  propagatedBuildInputs = [
    ffmpeg_7
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
