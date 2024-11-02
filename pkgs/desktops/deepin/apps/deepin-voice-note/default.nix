{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qttools,
  wrapQtAppsHook,
  qtbase,
  dtkwidget,
  qt5integration,
  qt5platform-plugins,
  qtsvg,
  dde-qt-dbus-factory,
  deepin-movie-reborn,
  qtmultimedia,
  qtwebengine,
  libvlc,
  gst_all_1,
  gtest,
}:

stdenv.mkDerivation rec {
  pname = "deepin-voice-note";
  version = "6.0.18";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-GbSYXwJoNfbg+31454GjMbXRqrtk2bSZJCk18ILfAn4=";
  };

  patches = [ ./use_v23_dbus_interface.diff ];

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

  buildInputs =
    [
      qtbase
      qtsvg
      dtkwidget
      qt5platform-plugins
      dde-qt-dbus-factory
      deepin-movie-reborn
      qtmultimedia
      qtwebengine
      libvlc
      gtest
    ]
    ++ (with gst_all_1; [
      gstreamer
      gst-plugins-base
    ]);

  strictDeps = true;

  cmakeFlags = [ "-DVERSION=${version}" ];

  # qt5integration must be placed before qtsvg in QT_PLUGIN_PATH
  qtWrapperArgs = [
    "--prefix QT_PLUGIN_PATH : ${qt5integration}/${qtbase.qtPluginPrefix}"
    "--prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        gst_all_1.gstreamer
        gst_all_1.gst-plugins-base
      ]
    }"
  ];

  preFixup = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = {
    description = "Simple memo software with texts and voice recordings";
    mainProgram = "deepin-voice-note";
    homepage = "https://github.com/linuxdeepin/deepin-voice-note";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
}
