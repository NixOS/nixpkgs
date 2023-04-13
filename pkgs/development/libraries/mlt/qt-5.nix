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
, opencv4
, ladspa-sdk
, gitUpdater
, ladspaPlugins
, rubberband
, mkDerivation
, which
}:

mkDerivation rec {
  pname = "mlt";
  version = "7.14.0";

  src = fetchFromGitHub {
    owner = "mltframework";
    repo = "mlt";
    rev = "v${version}";
    sha256 = "sha256-BmvgDj/zgGJNpTy5A9XPOl+9001Kc0qSFSqQ3gwZPmI=";
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
    qtbase
    qtsvg
    sox
    fftw
    vid-stab
    opencv4
    ladspa-sdk
    ladspaPlugins
    rubberband
  ];

  nativeBuildInputs = [ cmake which pkg-config ];

  outputs = [ "out" "dev" ];

  cmakeFlags = [
    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-DMOD_OPENCV=ON"
  ];

  qtWrapperArgs = [
    "--prefix FREI0R_PATH : ${frei0r}/lib/frei0r-1"
    "--prefix LADSPA_PATH : ${ladspaPlugins}/lib/ladspa"
  ];

  postFixup = ''
    substituteInPlace "$dev"/lib/pkgconfig/mlt-framework-7.pc \
      --replace '=''${prefix}//' '=/'
  '';

  passthru = {
    inherit ffmpeg;
  };

  passthru.updateScript = gitUpdater {
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
