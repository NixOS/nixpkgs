{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, wrapQtAppsHook
, dtkwidget
, qt5integration
, qt5platform-plugins
, dde-qt-dbus-factory
, udisks2-qt5
, qtmpris
, qtdbusextended
, qtmultimedia
, qttools
, kcodecs
, ffmpeg
, libvlc
, libcue
, taglib
, gsettings-qt
, SDL2
, gtest
, qtbase
, gst_all_1
}:

stdenv.mkDerivation rec {
  pname = "deepin-music";
  version = "6.2.21";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-sN611COCWy1gF/BZZqZ154uYuRo9HsbJw2wXe9OJ+iQ=";
  };

  postPatch = ''
    substituteInPlace src/music-player/CMakeLists.txt \
      --replace "include_directories(/usr/include/vlc)" "include_directories(${libvlc}/include/vlc)" \
      --replace "include_directories(/usr/include/vlc/plugins)" "include_directories(${libvlc}/include/vlc/plugins)" \
      --replace "/usr/share" "$out/share"
    substituteInPlace src/libmusic-plugin/CMakeLists.txt \
      --replace "/usr/lib/deepin-aiassistant" "$out/lib/deepin-aiassistant"
    substituteInPlace src/music-player/data/deepin-music.desktop \
      --replace "/usr/bin/deepin-music" "$out/bin/deepin-music"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    dtkwidget
    qt5platform-plugins
    dde-qt-dbus-factory
    udisks2-qt5
    qtmpris
    qtdbusextended
    qtmultimedia
    kcodecs
    ffmpeg
    libvlc
    libcue
    taglib
    gsettings-qt
    SDL2
    gtest
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
  ]);

  # qt5integration must be placed before qtsvg in QT_PLUGIN_PATH
  qtWrapperArgs = [
    "--prefix QT_PLUGIN_PATH : ${qt5integration}/${qtbase.qtPluginPrefix}"
  ];

  cmakeFlags = [
    "-DVERSION=${version}"
  ];

  preFixup = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = with lib; {
    description = "Awesome music player with brilliant and tweakful UI Deepin-UI based";
    homepage = "https://github.com/linuxdeepin/deepin-music";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
