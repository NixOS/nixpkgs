{
  mkDerivation, lib,

  extra-cmake-modules, kdoctools,

  coreutils, dbus, gnugrep, gnused, libdbusmenu, pam, wayland, appstream,

  kdeclarative, kdelibs4support, kpeople, kconfig, krunner, kinit, kwayland, kwin,
  plasma-framework, telepathy, libphonenumber, protobuf,

  qtwayland, qttools
}:

let inherit (lib) getBin getLib; in

mkDerivation {
  name = "plasma-phone";

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    appstream libdbusmenu pam wayland
    kdeclarative kdelibs4support kpeople kconfig krunner kinit kwayland kwin
    plasma-framework telepathy libphonenumber protobuf
  ];
  outputs = [ "bin" "dev" "out" ];

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

  #preConfigure = ''
  #  NIX_CFLAGS_COMPILE+=" -DNIXPKGS_KDOSTARTUPCONFIG5=\"''${!outputBin}/bin/kdostartupconfig5\""
  #  cmakeFlags+=" -DNIXPKGS_STARTPLASMA=''${!outputBin}/lib/libexec/startplasma"
  #'';

  postInstall = ''
    moveToOutput lib/libexec/startplasma ''${!outputBin}
  '';
}
