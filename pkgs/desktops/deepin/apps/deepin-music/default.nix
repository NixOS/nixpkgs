{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, qttools
, wrapQtAppsHook
, dtkwidget
, dtkdeclarative
, qt5integration
, qt5platform-plugins
, udisks2-qt5
, qtmpris
, qtmultimedia
, kcodecs
, ffmpeg
, libvlc
, taglib
, SDL2
, qtbase
, gst_all_1
}:

stdenv.mkDerivation rec {
  pname = "deepin-music";
  version = "7.0.3";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-MLfkSO8ru8MKiwgiQ0mPO3zGlnIeSHPc0Op5jjzJ6PE=";
  };

  patches = [
    "${src}/patches/fix-library-path.patch"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    dtkwidget
    dtkdeclarative
    qt5integration
    qt5platform-plugins
    udisks2-qt5
    qtmpris
    qtmultimedia
    kcodecs
    ffmpeg
    libvlc
    taglib
    SDL2
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
  ]);

  cmakeFlags = [
    "-DVERSION=${version}"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${libvlc}/include/vlc/plugins"
    "-I${libvlc}/include/vlc"
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
