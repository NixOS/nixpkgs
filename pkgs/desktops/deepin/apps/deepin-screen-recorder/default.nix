{
  stdenv,
  lib,
  fetchFromGitHub,
  qmake,
  pkg-config,
  qttools,
  wrapQtAppsHook,
  dtkwidget,
  qt5integration,
  dde-qt-dbus-factory,
  dde-dock,
  qtbase,
  qtmultimedia,
  qtx11extras,
  image-editor,
  gsettings-qt,
  xorg,
  libusb1,
  libv4l,
  ffmpeg,
  ffmpegthumbnailer,
  portaudio,
  kwayland,
  udev,
  gst_all_1,
}:

stdenv.mkDerivation rec {
  pname = "deepin-screen-recorder";
  version = "unstable-2023-07-10";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = "e8ee1e8330e2f3923e22acc952a0bd01bee94ad1";
    hash = "sha256-QHV3hSALXI4e31YBDXRSRgT8b/J8gwm024bzlPWu2FA=";
  };

  patches = [ ./dont_use_libPath.diff ];

  postPatch = ''
    (
      shopt -s globstar
      substituteInPlace **/*.pro **/*.service **/*.desktop \
        --replace "/usr/" "$out/"
    )
  '';

  nativeBuildInputs = [
    qmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs =
    [
      dtkwidget
      dde-qt-dbus-factory
      dde-dock
      qtbase
      qtmultimedia
      qtx11extras
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
      kwayland
      udev
    ]
    ++ (with gst_all_1; [
      gstreamer
      gst-plugins-base
      gst-plugins-good
    ]);

  # Fix build failure on dtk 5.6.20
  env.NIX_CFLAGS_COMPILE = "-std=c++14";

  # qt5integration must be placed before qtsvg in QT_PLUGIN_PATH
  qtWrapperArgs = [
    "--prefix QT_PLUGIN_PATH : ${qt5integration}/${qtbase.qtPluginPrefix}"
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

  meta = with lib; {
    description = "Screen recorder application for dde";
    homepage = "https://github.com/linuxdeepin/deepin-screen-recorder";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
