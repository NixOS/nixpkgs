{ alsaLib
, bctoolbox
, bzrtp
, cmake
, doxygen
, fetchFromGitLab
, fetchpatch
, ffmpeg_3
, glew
, gsm
, intltool
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
, python
, SDL
, speex
, srtp
, lib, stdenv
}:

stdenv.mkDerivation rec {
  pname = "mediastreamer2";
  version = "4.4.13";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "0w84v1ajhyysr41qaj7x4njwdak84cc10lq33hl8lq68a52fc2vw";
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
    python
  ];

  propagatedBuildInputs = [
    alsaLib
    bctoolbox
    bzrtp
    ffmpeg_3
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
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
