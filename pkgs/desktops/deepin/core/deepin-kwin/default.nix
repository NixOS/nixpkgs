{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wayland,
  dwayland,
  libsForQt5,
  extra-cmake-modules,
  gsettings-qt,
  libepoxy,
  libinput,
  libgbm,
  lcms2,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "deepin-kwin";
  version = "5.25.27";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-EjPPjdxa+iL/nXhuccoM3NiLmGXh7Un2aGz8O3sP6xE=";
  };

  patches = [ ./0001-hardcode-fallback-background.diff ];

  # Avoid using absolute path to distinguish applications
  postPatch = ''
    substituteInPlace src/effects/screenshot/screenshotdbusinterface1.cpp \
      --replace 'file.readAll().startsWith(DEFINE_DDE_DOCK_PATH"dde-dock")' 'file.readAll().contains("dde-dock")'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    extra-cmake-modules
    libsForQt5.wrapQtAppsHook
    libsForQt5.qttools
  ];

  buildInputs =
    [
      wayland
      dwayland
      libepoxy
      gsettings-qt

      libinput
      libgbm
      lcms2

      xorg.libxcb
      xorg.libXdmcp
      xorg.libXcursor
      xorg.xcbutilcursor
      xorg.libXtst
      xorg.libXScrnSaver
    ]
    ++ (with libsForQt5; [
      qtbase
      qtx11extras
      kconfig
      kconfigwidgets
      kcoreaddons
      kcrash
      kdbusaddons
      kiconthemes
      kglobalaccel
      kidletime
      knotifications
      kpackage
      plasma-framework
      kcmutils
      knewstuff
      kdecoration
      kscreenlocker
      breeze-qt5
    ]);

  cmakeFlags = [ "-DKWIN_BUILD_RUNNERS=OFF" ];

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    description = "Fork of kwin, an easy to use, but flexible, composited Window Manager";
    homepage = "https://github.com/linuxdeepin/deepin-kwin";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
}
