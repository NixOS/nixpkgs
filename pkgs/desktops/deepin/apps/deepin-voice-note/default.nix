{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, qttools
, wrapQtAppsHook
, qtbase
, dtkwidget
, qt5integration
, qt5platform-plugins
, qtsvg
, dde-qt-dbus-factory
, qtmultimedia
, qtwebengine
, libvlc
, gst_all_1
, gtest
}:

stdenv.mkDerivation rec {
  pname = "deepin-voice-note";
  version = "6.0.15";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-k6LFMs2/OQQyeGI5WXBGWkAAY4GeP8LaA8hTXFwbaCM=";
  };

  patches = [
    ./use_v23_dbus_interface.diff
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "/usr" "$out"
    substituteInPlace src/common/audiowatcher.cpp \
      --replace "/usr/share" "$out/share"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtsvg
    dtkwidget
    qt5platform-plugins
    dde-qt-dbus-factory
    qtmultimedia
    qtwebengine
    libvlc
    gtest
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
  ]);

  strictDeps = true;

  cmakeFlags = [ "-DVERSION=${version}" ];

  # qt5integration must be placed before qtsvg in QT_PLUGIN_PATH
  qtWrapperArgs = [
    "--prefix QT_PLUGIN_PATH : ${qt5integration}/${qtbase.qtPluginPrefix}"
  ];

  preFixup = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = with lib; {
    description = "Simple memo software with texts and voice recordings";
    mainProgram = "deepin-voice-note";
    homepage = "https://github.com/linuxdeepin/deepin-voice-note";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
