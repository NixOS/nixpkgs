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
  version = "7.8.0";

  src = fetchFromGitHub {
    owner = "mltframework";
    repo = "mlt";
    rev = "v${version}";
    sha256 = "sha256-r8lvzz083WWlDtjvlsPwvOgplx2lPPkDDf3t0G9PqAQ=";
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

  cmakeFlags = [
    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  qtWrapperArgs = [
    "--prefix FREI0R_PATH : ${frei0r}/lib/frei0r-1"
    "--prefix LADSPA_PATH : ${ladspaPlugins}/lib/ladspa"
  ];

  passthru = {
    inherit ffmpeg;
  };

  passthru.updateScript = gitUpdater {
    inherit pname version;
    attrPath = "libsForQt5.mlt";
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
