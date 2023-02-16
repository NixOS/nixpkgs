{ mkDerivation
, lib
, extra-cmake-modules
, kdoctools
, coreutils
, dbus
, gnugrep
, gnused
, libdbusmenu
, pam
, wayland
, appstream
, kdeclarative
, kdelibs4support
, kpeople
, kconfig
, krunner
, kinit
, kirigami-addons
, kwayland
, kwin
, plasma-framework
, telepathy
, libphonenumber
, protobuf
, libqofono
, modemmanager-qt
, networkmanager-qt
, plasma-workspace
, maliit-framework
, maliit-keyboard
, qtfeedback
, qtwayland
, qttools
}:

let inherit (lib) getBin getLib; in

mkDerivation {
  pname = "plasma-mobile";

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    appstream
    libdbusmenu
    pam
    wayland
    kdeclarative
    kdelibs4support
    kpeople
    kconfig
    krunner
    kinit
    kirigami-addons
    kwayland
    kwin
    plasma-framework
    telepathy
    libphonenumber
    protobuf
    libqofono
    modemmanager-qt
    networkmanager-qt
    maliit-framework
    maliit-keyboard
    plasma-workspace
    qtfeedback
  ];

  postPatch = ''
    substituteInPlace bin/startplasmamobile.in \
      --replace @KDE_INSTALL_FULL_LIBEXECDIR@ "${plasma-workspace}/libexec"

    substituteInPlace bin/plasma-mobile.desktop.cmake \
      --replace @CMAKE_INSTALL_FULL_LIBEXECDIR@ "${plasma-workspace}/libexec"
  '';

  # Ensures dependencies like libqofono (at the very least) are present for the shell.
  preFixup = ''
    wrapQtApp "$out/bin/startplasmamobile"
  '';

  passthru.providedSessions = [ "plasma-mobile" ];
}
