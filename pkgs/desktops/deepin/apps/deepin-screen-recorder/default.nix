{ stdenv
, lib
, fetchFromGitHub
, qmake
, pkg-config
, qttools
, wrapQtAppsHook
, dtkwidget
, qt5integration
, dde-qt-dbus-factory
, dde-dock
, qtbase
, qtmultimedia
, qtx11extras
, image-editor
, gsettings-qt
, xorg
, libusb1
, libv4l
, ffmpeg
, ffmpegthumbnailer
, portaudio
, kwayland
, udev
, gst_all_1
}:
stdenv.mkDerivation rec {
  pname = "deepin-screen-recorder";
  version = "5.12.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-43jqgiBa77UAes0ekMES6IqVOPVXfzfQQjePdxFkNDM=";
  };

  patches = [ ./dont_use_libPath.diff ];

  postPatch = ''
    substituteInPlace screen_shot_recorder.pro deepin-screen-recorder.desktop \
      src/{src.pro,pin_screenshots/pin_screenshots.pro} \
      src/dde-dock-plugins/{shotstart/shotstart.pro,recordtime/recordtime.pro} \
      assets/com.deepin.Screenshot.service \
     --replace "/usr" "$out"
  '';

  nativeBuildInputs = [
    qmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
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
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
  ]);

  # qt5integration must be placed before qtsvg in QT_PLUGIN_PATH
  qtWrapperArgs = [
    "--prefix QT_PLUGIN_PATH : ${qt5integration}/${qtbase.qtPluginPrefix}"
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ udev gst_all_1.gstreamer libv4l ]}"
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
