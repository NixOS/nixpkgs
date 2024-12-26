{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  libsForQt5,
  dtkwidget,
  qt5integration,
  dde-qt-dbus-factory,
  image-editor,
  gsettings-qt,
  xorg,
  libusb1,
  libv4l,
  ffmpeg,
  ffmpegthumbnailer,
  portaudio,
  dwayland,
  udev,
  gst_all_1,
}:

stdenv.mkDerivation rec {
  pname = "deepin-screen-recorder";
  version = "6.0.6";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-nE+axTUxWCcgrxQ5y2cjkVswW2rwv/We0m7XgB4shko=";
  };

  patches = [ ./dont_use_libPath.diff ];

  # disable dock plugins, it's part of dde-shell now
  postPatch = ''
    substituteInPlace screen_shot_recorder.pro \
      --replace-fail " src/dde-dock-plugins" ""
    (
      shopt -s globstar
      substituteInPlace **/*.pro **/*.service **/*.desktop \
        --replace-quiet "/usr/" "$out/"
    )
  '';

  nativeBuildInputs = [
    libsForQt5.qmake
    pkg-config
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs =
    [
      dtkwidget
      dde-qt-dbus-factory
      qt5integration
      libsForQt5.qtbase
      libsForQt5.qtmultimedia
      libsForQt5.qtx11extras
      image-editor
      gsettings-qt
      xorg.libXdmcp
      xorg.libXtst
      xorg.libXcursor
      libusb1
      libv4l
      ffmpeg
      ffmpegthumbnailer
      portaudio
      dwayland
      udev
    ]
    ++ (with gst_all_1; [
      gstreamer
      gst-plugins-base
      gst-plugins-good
    ]);

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        udev
        gst_all_1.gstreamer
        libv4l
        ffmpeg
        ffmpegthumbnailer
      ]
    }"
  ];

  preFixup = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = {
    description = "Screen recorder application for dde";
    homepage = "https://github.com/linuxdeepin/deepin-screen-recorder";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
    broken = true;
  };
}
