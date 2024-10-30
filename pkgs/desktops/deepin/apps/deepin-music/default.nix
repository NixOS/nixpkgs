{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  dtk6widget,
  dtk6declarative,
  qt6integration,
  qt6platform-plugins,
  qt6mpris,
  ffmpeg_6,
  libvlc,
  qt6Packages,
  taglib,
  SDL2,
  gst_all_1,
}:

stdenv.mkDerivation rec {
  pname = "deepin-music";
  version = "7.0.9";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-tj0XICmp7sM2m6aSf/DgxS7JXO3Wy/83sZIPGV17gFo=";
  };

  patches = [ "${src}/patches/fix-library-path.patch" ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6Packages.qttools
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs =
    [
      dtk6widget
      dtk6declarative
      qt6integration
      qt6platform-plugins
      qt6mpris
      qt6Packages.qtbase
      qt6Packages.qt5compat
      qt6Packages.qtmultimedia
      ffmpeg_6
      libvlc
      taglib
      SDL2
    ]
    ++ (with gst_all_1; [
      gstreamer
      gst-plugins-base
      gst-plugins-good
    ]);

  cmakeFlags = [ "-DVERSION=${version}" ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${libvlc}/include/vlc/plugins"
    "-I${libvlc}/include/vlc"
  ];

  # qtmultimedia can't not be found with strictDeps
  strictDeps = false;

  preFixup = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = {
    description = "Awesome music player with brilliant and tweakful UI Deepin-UI based";
    mainProgram = "deepin-music";
    homepage = "https://github.com/linuxdeepin/deepin-music";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
}
