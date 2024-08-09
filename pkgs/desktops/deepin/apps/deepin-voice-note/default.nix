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
, deepin-movie-reborn
, qtmultimedia
, qtwebengine
, libvlc
, ffmpeg
, ffmpegthumbnailer
, mpv
, gst_all_1
, gtest
, gitUpdater
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
    deepin-movie-reborn # for libdrm
    qtmultimedia
    qtwebengine
    libvlc
    gtest
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
  ]);

  strictDeps = true;

  cmakeFlags = [ "-DVERSION=${version}" ];

  qtWrapperArgs = [
    # qt5integration must be placed before qtsvg in QT_PLUGIN_PATH
    "--prefix QT_PLUGIN_PATH : ${qt5integration}/${qtbase.qtPluginPrefix}"
    # libdrm use dlopen to search runtime dependency
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libvlc ffmpeg ffmpegthumbnailer mpv gst_all_1.gstreamer gst_all_1.gst-plugins-base ]}"
  ];

  preFixup = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Simple memo software with texts and voice recordings";
    mainProgram = "deepin-voice-note";
    homepage = "https://github.com/linuxdeepin/deepin-voice-note";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
