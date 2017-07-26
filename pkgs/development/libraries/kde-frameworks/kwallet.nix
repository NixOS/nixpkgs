{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kconfig, kconfigwidgets, kcoreaddons , kdbusaddons, ki18n,
  kiconthemes, knotifications, kservice, kwidgetsaddons, kwindowsystem,
  libgcrypt, qgpgme, qtbase,
}:

mkDerivation {
  name = "kwallet";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kconfig kconfigwidgets kcoreaddons kdbusaddons ki18n kiconthemes
    knotifications kservice kwidgetsaddons kwindowsystem libgcrypt qgpgme
  ];
  propagatedBuildInputs = [ qtbase ];
  patches = [ ./kwallet-dbus.patch ];
}
