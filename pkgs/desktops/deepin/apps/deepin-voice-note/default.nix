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
, dde-qt-dbus-factory
, qtmultimedia
, qtwebengine
, libvlc
, gst_all_1
, gtest
}:
stdenv.mkDerivation rec {
  pname = "deepin-voice-note";
  version = "5.11.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-JX4OuVu+5/a3IhkfnvaWVDaKl+xg/8qxlvp9hM0nHNU=";
  };

  postPatch = ''
    substituteInPlace src/common/audiowatcher.cpp \
      --replace "/usr/share" "$out/share"
    substituteInPlace assets/deepin-voice-note.desktop \
      --replace "/usr/bin" "$out/bin"
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

  env.NIX_CFLAGS_COMPILE = "-I${dde-qt-dbus-factory}/include/libdframeworkdbus-2.0";

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
