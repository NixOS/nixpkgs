{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kactivities, karchive, kconfig, kconfigwidgets, kcoreaddons, kdbusaddons,
  kdeclarative, kglobalaccel, kguiaddons, ki18n, kiconthemes, kio,
  knotifications, kpackage, kservice, kwayland, kwindowsystem, kxmlgui,
  qtbase, qtdeclarative, qtscript, qtx11extras,
}:

mkDerivation {
  name = "plasma-framework";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kactivities karchive kconfig kconfigwidgets kcoreaddons kdbusaddons
    kdeclarative kglobalaccel kguiaddons ki18n kiconthemes kio knotifications
    kwayland kwindowsystem kxmlgui qtdeclarative qtscript qtx11extras
  ];
  propagatedBuildInputs = [ kpackage kservice qtbase ];
}
