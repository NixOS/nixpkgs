{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, extra-cmake-modules
, deepin-gettext-tools
, wrapQtAppsHook
, makeWrapper
, dtkcore
, qtbase
, qtx11extras
, gsettings-qt
, xorg
, libepoxy
, deepin-kwin
, kdecoration
, kconfig
, kwayland
, kwindowsystem
, kglobalaccel
}:

stdenv.mkDerivation rec {
  pname = "dde-kwin";
  version = "5.6.5";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = "b5c00527b86f773595c786c8015d60f8be3a681b";
    sha256 = "sha256-qXN9AwjLnqO5BpnrX5PaSCKZ6ff874r08ubCMM272tA=";
  };

  /*
    This is the final version of dde-kwin, upstream has been archived.
    We should remove this package when deepin-kwin release a new version.
  */

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "/usr/include/KWaylandServer" "${kwayland.dev}/include/KWaylandServer"
    substituteInPlace deepin-wm-dbus/deepinwmfaker.cpp \
      --replace "/usr/lib/deepin-daemon" "/run/current-system/sw/lib/deepin-daemon" \
      --replace "/usr/share/backgrounds" "/run/current-system/sw/share/backgrounds" \
      --replace "/usr/share/wallpapers" "/run/current-system/sw/share/wallpapers"
    patchShebangs .
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    extra-cmake-modules
    deepin-gettext-tools
    wrapQtAppsHook
    makeWrapper
  ];

  buildInputs = [
    dtkcore
    qtbase
    qtx11extras
    gsettings-qt
    xorg.libXdmcp
    libepoxy
    deepin-kwin
    kdecoration
    kconfig
    kwayland
    kwindowsystem
    kglobalaccel
  ];

  cmakeFlags = [
    "-DPROJECT_VERSION=${version}"
    "-DQT_INSTALL_PLUGINS=${placeholder "out"}/${qtbase.qtPluginPrefix}"
  ];

  # kwin_no_scale is a shell script
  postFixup = ''
    wrapProgram $out/bin/kwin_no_scale \
      --set QT_QPA_PLATFORM_PLUGIN_PATH "${placeholder "out"}/${qtbase.qtPluginPrefix}"
  '';

  meta = with lib; {
    description = "KWin configuration for Deepin Desktop Environment";
    homepage = "https://github.com/linuxdeepin/dde-kwin";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
