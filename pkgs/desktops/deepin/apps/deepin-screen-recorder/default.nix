{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
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
  version = "unstable-2023-12-18";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = "f284ff1b6105e2e8d4629090c16939eec29652e1";
    hash = "sha256-kXB7Oo2cVfwmb5Iaq5DF6yhLfWLkJXUb3yMHyFvCQ6A=";
  };

  patches = [
    ./dont_use_libPath.diff
    (fetchpatch {
      name = "fix-crash-on-ffmpeg-6.patch";
      url = "https://github.com/linuxdeepin/deepin-screen-recorder/commit/25fce179a5502c33f61f6ea9791d0f5d5c57a699.diff";
      hash = "sha256-g+uGCxo4Z6Gaj46AKNLz6znPBJejLTmJyEceJU023JU=";
    })
  ];

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
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ udev gst_all_1.gstreamer libv4l ffmpeg ffmpegthumbnailer ]}"
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
