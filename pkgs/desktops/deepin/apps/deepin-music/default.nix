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
, libpulseaudio
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
  version = "6.2.31";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-OXyHB47orv9ix+Jg0b7wciA6DWUsXzFmIg4SM+piO3c=";
  };

  postPatch = ''
    substituteInPlace src/music-player/CMakeLists.txt \
      --replace "/usr/include/vlc" "${libvlc}/include/vlc"
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
    qt5integration
    qt5platform-plugins
    dde-qt-dbus-factory
    udisks2-qt5
    qtmpris
    qtdbusextended
    qtmultimedia
    kcodecs
    ffmpeg
    libvlc
    libpulseaudio
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

  cmakeFlags = [
    "-DVERSION=${version}"
  ];

  strictDeps = true;

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
