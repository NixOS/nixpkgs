{
  mkDerivation,
  extra-cmake-modules,
  qtbase,
  kfilemetadata, kio, ki18n, kconfig , kdbusaddons, knotifications, kpurpose,
  krunner, kwindowsystem, kactivities, plasma-workspace
}:

mkDerivation {
  name = "plasma-browser-integration";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    qtbase kfilemetadata kio ki18n kconfig kdbusaddons knotifications kpurpose
    krunner kwindowsystem kactivities plasma-workspace
  ];
}
