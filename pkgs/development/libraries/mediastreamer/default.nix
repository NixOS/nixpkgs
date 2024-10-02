{ bctoolbox
, bzrtp
, cmake
, fetchFromGitLab
, fetchpatch2
, ffmpeg_7
, glew
, gsm
, lib
, libX11
, libXext
, libopus
, libpulseaudio
, libv4l
, libvpx
, ortp
, python3
, qtbase
, qtdeclarative
, speex
, srtp
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "mediastreamer2";
  version = "5.2.111";

  dontWrapQtApps = true;

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    hash = "sha256-Le52tsyzOpepmvb+GOGCPwwTriPUjhYpa6GM+y/6USA=";
  };

  patches = [
    # Plugins directory is normally fixed during compile time. This patch makes
    # it possible to set the plugins directory run time with an environment
    # variable MEDIASTREAMER_PLUGINS_DIR. This makes it possible to construct a
    # plugin directory with desired plugins and wrap executables so that the
    # environment variable points to that directory.
    ./plugins_dir.patch

    # Port to ffmpeg 5.0 API
    (fetchpatch2 {
      url = "https://salsa.debian.org/pkg-voip-team/linphone-stack/mediastreamer2/-/raw/4e7784802d2eac57dffe210c8c23e696f40ac6ec/debian/patches/ffmpeg_5_0_fixes.patch";
      hash = "sha256-5ay4iVbx8IOX952HEFaKLBGKLRYUWRntufciApUVhh0=";
    })
  ];

  nativeBuildInputs = [
    cmake
    python3
    qtbase
    qtdeclarative
  ];

  propagatedBuildInputs = [
    # Made by BC
    bctoolbox
    bzrtp
    ortp

    ffmpeg_7
    glew
    libX11
    libXext
    libpulseaudio
    libv4l
    speex
    srtp

    # Optional
    gsm  # GSM audio codec
    libopus  # Opus audio codec
    libvpx  # VP8 video codec
  ];

  strictDeps = true;

  cmakeFlags = [
    "-DENABLE_STATIC=NO" # Do not build static libraries
    "-DENABLE_QT_GL=ON" # Build necessary MSQOGL plugin for Linphone desktop
    "-DCMAKE_C_FLAGS=-DGIT_VERSION=\"v${version}\""
    "-DENABLE_STRICT=NO" # Disable -Werror
    "-DENABLE_UNIT_TESTS=NO" # Do not build test executables
  ];

  NIX_LDFLAGS = "-lXext";

  meta = with lib; {
    description = "Powerful and lightweight streaming engine specialized for voice/video telephony applications. Part of the Linphone project";
    homepage = "https://www.linphone.org/technical-corner/mediastreamer2";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
