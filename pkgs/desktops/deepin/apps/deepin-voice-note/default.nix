{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, qttools
, wrapQtAppsHook
, qtbase
, dtkwidget
, qt5integration
, qt5platform-plugins
, dde-qt-dbus-factory
, qtmultimedia
, qtwebengine
, libvlc
, gst_all_1
, gtest
}:

stdenv.mkDerivation rec {
  pname = "deepin-voice-note";
  version = "6.0.13";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-yDlWyMGkSToGCN7tuZNR8Mz7MUOZ7355w4H0OzeHBrs=";
  };

  patches = [
    ./use_v23_dbus_interface.diff
    (fetchpatch {
      name = "Adjust-the-audio-port-available-range.patch";
      url = "https://github.com/linuxdeepin/deepin-voice-note/commit/a876e4c4cf7d77e50071246f9fb6998aa62def77.patch";
      hash = "sha256-J/PPdj1Am/v2Sw2Dv2XvZJAy/6Tf7OoTfrbOB9rc5m8=";
    })
    (fetchpatch {
      name = "fix-build-error-with-new-dtk.patch";
      url = "https://github.com/linuxdeepin/deepin-voice-note/commit/9ce211f603deaff21b881e1c4f43d53e33a85347.patch";
      hash = "sha256-oP+AzMniONxjYIFust8fGaD8/UOjKr4yZiRUkdTMd5w=";
    })
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
    dtkwidget
    qt5integration
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

  preFixup = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = with lib; {
    description = "Simple memo software with texts and voice recordings";
    homepage = "https://github.com/linuxdeepin/deepin-voice-note";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
