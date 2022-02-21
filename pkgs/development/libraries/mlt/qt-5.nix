{ lib
, fetchFromGitHub
, cmake
, SDL
, ffmpeg
, frei0r
, libjack2
, libdv
, libsamplerate
, libvorbis
, libxml2
, movit
, pkg-config
, sox
, qtbase
, qtsvg
, fftw
, vid-stab
, opencv3
, ladspa-sdk
, gitUpdater
, ladspaPlugins
, mkDerivation
, which
}:

mkDerivation rec {
  pname = "mlt";
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "mltframework";
    repo = "mlt";
    rev = "v${version}";
    sha256 = "13c5miph9jjbz69dhy0zvbkk5zbb05dr3vraaci0d5fdbrlhyscf";
  };

  buildInputs = [
    SDL
    ffmpeg
    frei0r
    libjack2
    libdv
    libsamplerate
    libvorbis
    libxml2
    movit
    pkg-config
    qtbase
    qtsvg
    sox
    fftw
    vid-stab
    opencv3
    ladspa-sdk
    ladspaPlugins
  ];

  nativeBuildInputs = [ cmake which ];

  outputs = [ "out" "dev" ];

  qtWrapperArgs = [
    "--prefix FREI0R_PATH : ${frei0r}/lib/frei0r-1"
    "--prefix LADSPA_PATH : ${ladspaPlugins}/lib/ladspa"
  ];

  passthru = {
    inherit ffmpeg;
  };

  passthru.updateScript = gitUpdater {
    inherit pname version;
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Open source multimedia framework, designed for television broadcasting";
    homepage = "https://www.mltframework.org/";
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
