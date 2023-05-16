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
<<<<<<< HEAD
, libpulseaudio
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "6.2.31";
=======
  version = "6.2.21";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-OXyHB47orv9ix+Jg0b7wciA6DWUsXzFmIg4SM+piO3c=";
=======
    sha256 = "sha256-sN611COCWy1gF/BZZqZ154uYuRo9HsbJw2wXe9OJ+iQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace src/music-player/CMakeLists.txt \
<<<<<<< HEAD
      --replace "/usr/include/vlc" "${libvlc}/include/vlc"
=======
      --replace "/usr/include/vlc" "${libvlc}/include/vlc" \
      --replace "/usr/share" "$out/share"
    substituteInPlace src/libmusic-plugin/CMakeLists.txt \
      --replace "/usr/lib/deepin-aiassistant" "$out/lib/deepin-aiassistant"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    libpulseaudio
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
