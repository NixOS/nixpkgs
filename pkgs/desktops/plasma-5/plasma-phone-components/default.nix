{
  mkDerivation, lib,

  extra-cmake-modules, kdoctools,

  coreutils, dbus, gnugrep, gnused, libdbusmenu, pam, wayland, appstream,

  kdeclarative, kdelibs4support, kpeople, kconfig, krunner, kinit, kwayland, kwin,
  plasma-framework, telepathy, libphonenumber, protobuf, libqofono,
  plasma-workspace,
  maliit-framework, maliit-keyboard,

  qtwayland, qttools
}:

let inherit (lib) getBin getLib; in

mkDerivation {
  name = "plasma-phone-components";

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    appstream libdbusmenu pam wayland
    kdeclarative kdelibs4support kpeople kconfig krunner kinit kwayland kwin
    plasma-framework telepathy libphonenumber protobuf libqofono
    maliit-framework maliit-keyboard
  ];

  postPatch = ''
    substituteInPlace bin/kwinwrapper.in \
      --replace @KDE_INSTALL_FULL_LIBEXECDIR@ "${plasma-workspace}/libexec"

    substituteInPlace bin/plasma-mobile.desktop.cmake \
      --replace @CMAKE_INSTALL_FULL_LIBEXECDIR@ "${plasma-workspace}/libexec"
  '';

  cmakeFlags = [
    "-DNIXPKGS_MKDIR=${getBin coreutils}/bin/mkdir"
    "-DNIXPKGS_ID=${getBin coreutils}/bin/id"
    "-DNIXPKGS_DBUS_UPDATE_ACTIVATION_ENVIRONMENT=${getBin dbus}/bin/dbus-update-activation-environment"
    "-DNIXPKGS_START_KDEINIT_WRAPPER=${getLib kinit}/lib/libexec/kf5/start_kdeinit_wrapper"
    "-DNIXPKGS_QDBUS=${getBin qttools}/bin/qdbus"
    "-DNIXPKGS_KWRAPPER5=${getBin kinit}/bin/kwrapper5"
    "-DNIXPKGS_KREADCONFIG5=${getBin kconfig}/bin/kreadconfig5"
    "-DNIXPKGS_GREP=${getBin gnugrep}/bin/grep"
    "-DNIXPKGS_KDEINIT5_SHUTDOWN=${getBin kinit}/bin/kdeinit5_shutdown"
    "-DNIXPKGS_SED=${getBin gnused}/bin/sed"
  ];

  # Ensures dependencies like libqofono (at the very least) are present for the shell.
  preFixup = ''
    wrapQtApp "$out/bin/kwinwrapper"
  '';

  passthru.providedSessions = [ "plasma-mobile" ];
}
