{ alsaLib
, bctoolbox
, bzrtp
, cmake
, doxygen
, fetchFromGitLab
, fetchpatch
, ffmpeg
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
, pkgconfig
, python
, SDL
, speex
, srtp
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "mediastreamer2";
  # Using master branch for linphone-desktop caused a chain reaction that many
  # of its dependencies needed to use master branch too.
  version = "unstable-2020-03-20";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = "c5eecb72cb44376d142949051dd0cb7c982608fb";
    sha256 = "1vp260jxvjlmrmjdl4p23prg4cjln20a7z6zq8dqvfh4iq3ya033";
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
    pkgconfig
    python
  ];

  propagatedBuildInputs = [
    alsaLib
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

  meta = with stdenv.lib; {
    description = "A powerful and lightweight streaming engine specialized for voice/video telephony applications";
    homepage = "http://www.linphone.org/technical-corner/mediastreamer2";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
