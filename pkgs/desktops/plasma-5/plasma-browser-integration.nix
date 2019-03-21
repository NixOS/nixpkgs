{ mkDerivation, extra-cmake-modules, qtbase, kio, ki18n, kconfig
, kdbusaddons, knotifications, krunner, kwindowsystem, kactivities
}:

mkDerivation {
  name = "plasma-browser-integration";
  nativeBuildInputs = [
    extra-cmake-modules qtbase kio ki18n kconfig kdbusaddons
    knotifications krunner kwindowsystem kactivities
  ];
}
