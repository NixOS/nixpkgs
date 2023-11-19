{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, wayland
, dwayland
, qtbase
, qttools
, qtx11extras
, wrapQtAppsHook
, extra-cmake-modules
, gsettings-qt
, libepoxy
, kconfig
, kconfigwidgets
, kcoreaddons
, kcrash
, kdbusaddons
, kiconthemes
, kglobalaccel
, kidletime
, knotifications
, kpackage
, plasma-framework
, kcmutils
, knewstuff
, kdecoration
, kscreenlocker
, breeze-qt5
, libinput
, mesa
, lcms2
, xorg
}:

stdenv.mkDerivation rec {
  pname = "deepin-kwin";
  version = "5.24.3-deepin.1.9";

  /*
    There are no buildable tag in github:
      - 5.15 tag in eagel branch is used for UOS, it's too old to compile.
      - 5.25 tag in master branch only work on unreleased deepin v23.
    Since deepin-kwin was not maintained on github before, we lost all
    tags in master branch, this version is read from debian/changelog
  */

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = "98c9085670938937e2a1ce964f6acddc5c1d6eb5";
    sha256 = "sha256-/hgDuaDrpwAQsMIoaS8pGBJwWfJSrq6Yjic3a60ITtM=";
  };

  # Avoid using absolute path to distinguish applications
  postPatch = ''
    substituteInPlace src/effects/screenshot/screenshotdbusinterface1.cpp \
      --replace 'file.readAll().startsWith(DEFINE_DDE_DOCK_PATH"dde-dock")' 'file.readAll().contains("dde-dock")'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    wayland
    dwayland
    libepoxy
    gsettings-qt

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
    libinput
    mesa
    lcms2

    xorg.libxcb
    xorg.libXdmcp
    xorg.libXcursor
    xorg.xcbutilcursor
    xorg.libXtst
  ];

  cmakeFlags = [
    "-DKWIN_BUILD_RUNNERS=OFF"
  ];

  outputs = [ "out" "dev" ];

  meta = with lib; {
    description = "Fork of kwin, an easy to use, but flexible, composited Window Manager";
    homepage = "https://github.com/linuxdeepin/deepin-kwin";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
