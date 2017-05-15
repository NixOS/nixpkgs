{
  mkDerivation, lib,
  extra-cmake-modules,
  kbookmarks, kcompletion, kconfig, kconfigwidgets, ki18n, kiconthemes, kio,
  knewstuff, knotifications, kpackage, kwidgetsaddons, libXcursor, qtx11extras
}:

mkDerivation {
  name = "frameworkintegration";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    kbookmarks kcompletion kconfig kconfigwidgets ki18n kio kiconthemes
    knewstuff knotifications kpackage kwidgetsaddons libXcursor qtx11extras
  ];
}
