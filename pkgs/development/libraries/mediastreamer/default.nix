{ alsa-lib
, bctoolbox
, bzrtp
, cmake
, doxygen
, fetchFromGitLab
, ffmpeg
, glew
, gsm
, intltool
, lib
, libGL
, libGLU
, libX11
, libXext
, libXv
, libmatroska
, libopus
, libpcap
, libpulseaudio
, libtheora
, libupnp
, libv4l
, libvpx
, ortp
, pkg-config
, python3
, SDL
, speex
, srtp
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "mediastreamer2";
  version = "4.5.15";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "sha256-n/EuXEQ9nJKC32PMvWkfP1G+E6uQQuu1/A168n8/cIY=";
  };

  patches = [
    # Plugins directory is normally fixed during compile time. This patch makes
    # it possible to set the plugins directory run time with an environment
    # variable MEDIASTREAMER_PLUGINS_DIR. This makes it possible to construct a
    # plugin directory with desired plugins and wrap executables so that the
    # environment variable points to that directory.
    ./plugins_dir.patch
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    intltool
    pkg-config
    python3
  ];

  propagatedBuildInputs = [
    alsa-lib
    bctoolbox
    bzrtp
    ffmpeg
    glew
    gsm
    libGL
    libGLU
    libX11
    libXext
    libXv
    libmatroska
    libopus
    libpcap
    libpulseaudio
    libtheora
    libupnp
    libv4l
    libvpx
    ortp
    SDL
    speex
    srtp
  ];

  strictDeps = true;

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  NIX_CFLAGS_COMPILE = toString [
    "-DGIT_VERSION=\"v${version}\""
    "-Wno-error=deprecated-declarations"
    "-Wno-error=cast-function-type"
    "-Wno-error=stringop-truncation"
    "-Wno-error=stringop-overflow"
  ];
  NIX_LDFLAGS = "-lXext";

  meta = with lib; {
    description = "A powerful and lightweight streaming engine specialized for voice/video telephony applications";
    homepage = "http://www.linphone.org/technical-corner/mediastreamer2";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
