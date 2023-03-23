{ stdenv, lib, qt5ct, xdg-user-dirs, xwayland, wayqt, ipc, login1, status-notifier, applications, CuboCore, ninja, meson, fetchFromGitLab, xdg-desktop-portal, xdg-desktop-portal-kde, xdg-desktop-portal-gtk, xdg-desktop-portal-wlr, wayland, wayland-protocols, wayfire, libsForQt5, pkg-config, cmake, glib, wrapQtAppsHook, qtbase }:

stdenv.mkDerivation rec {
  pname = "paper/paperde";
  version = "v0.2.1";
  src = fetchFromGitLab {
    hash = "sha256-eYbFcmVfXithJjmMVNN7nX+9DBYhpiaBv27JAMiPua8=";
    domain = "gitlab.com";
    owner = "cubocore";
    repo = pname;
    rev = version;
  };
  outputs = [ "out" ];
  buildInputs = [
    wayland
    wayqt
    login1
    status-notifier
    ipc
    applications
    ninja
    meson
    pkg-config
    cmake
    CuboCore.libcprime
    CuboCore.libcsys
    wayfire
    libsForQt5.qt5.qtbase
    libsForQt5.qt5.qtsvg
    libsForQt5.qt5.qttools
    libsForQt5.libdbusmenu
    wayland
    wayland-protocols
    xwayland
    wrapQtAppsHook
  ];
  passthru.providedSessions = [ "paperdesktop" ];
  mesonFlags = [ "--prefix=${placeholder "out"} --buildtype=release" ];

  patches = [
    ./0001-fix-application-dirs.patch
  ];

  postPatch = ''
    substituteInPlace ./sessionmanager/paperdesktop.desktop --replace /usr/bin $out/bin
    substituteInPlace ./papershell/shell/papershell.conf --replace /usr/share/ $out/share
    substituteInPlace ./papershell/shell/papershell.conf --replace /usr/lib/coreapps/plugins $out/lib/paperde/plugins
    substituteInPlace ./sessionmanager/wayfire.ini.in --replace /usr/libexec/xdg-desktop-portal ${xdg-desktop-portal}/libexec/xdg-desktop-portal
    substituteInPlace ./sessionmanager/wayfire.ini.in --replace /usr/libexec/xdg-desktop-portal-wlr ${xdg-desktop-portal-wlr}/libexec/xdg-desktop-portal-wlr
    substituteInPlace ./settings/org.cubocore.PaperSettings.desktop --replace Exec=papersettings Exec=${placeholder "out"}/bin/papersettings
    mkdir -p $out/lib/paperde/plugins
    for p in "${CuboCore.coreaction}/lib/coreapps/plugins/*" "${CuboCore.coretoppings}/lib/coreapps/plugins/*";
    do
      ln -sf $p $out/lib/paperde/plugins/$(basename $p)
    done
  '';

  meta = with lib; {
    description = "An awesome Desktop Environment built on top of Qt/Wayland and wayfire";
    homepage = "https://gitlab.com/cubocore/paper/paperde";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
