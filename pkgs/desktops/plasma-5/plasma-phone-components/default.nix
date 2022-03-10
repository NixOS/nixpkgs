{
  mkDerivation, lib,

  extra-cmake-modules, kdoctools,

  coreutils, dbus, gnugrep, gnused, libdbusmenu, pam, wayland, appstream,

  kdeclarative, kdelibs4support, kpeople, kconfig, krunner, kinit, kwayland, kwin,
  plasma-framework, telepathy, libphonenumber, protobuf, libqofono, modemmanager-qt,
  plasma-workspace,
  maliit-framework, maliit-keyboard,

  qtwayland, qttools
}:

let inherit (lib) getBin getLib; in

mkDerivation {
  pname = "plasma-phone-components";

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    appstream libdbusmenu pam wayland
    kdeclarative kdelibs4support kpeople kconfig krunner kinit kwayland kwin
    plasma-framework telepathy libphonenumber protobuf libqofono modemmanager-qt
    maliit-framework maliit-keyboard
  ];

  postPatch = ''
    substituteInPlace bin/kwinwrapper.in \
      --replace @KDE_INSTALL_FULL_LIBEXECDIR@ "${plasma-workspace}/libexec"

    substituteInPlace bin/plasma-mobile.desktop.cmake \
      --replace @CMAKE_INSTALL_FULL_LIBEXECDIR@ "${plasma-workspace}/libexec"
  '';

  # Ensures dependencies like libqofono (at the very least) are present for the shell.
  preFixup = ''
    wrapQtApp "$out/bin/kwinwrapper"
  '';

  passthru.providedSessions = [ "plasma-mobile" ];
}
