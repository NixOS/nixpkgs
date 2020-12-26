{
  mkDerivation, lib,
  extra-cmake-modules,
  kbookmarks, kcompletion, kconfig, kconfigwidgets, ki18n, kiconthemes, kio,
  knewstuff, knotifications, kpackage, kwidgetsaddons, libXcursor, qtx11extras,
  appstream-qt, packagekit-qt
}:

mkDerivation {
  name = "frameworkintegration";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kbookmarks kcompletion kconfig ki18n kio knewstuff knotifications kpackage
    kwidgetsaddons libXcursor qtx11extras appstream-qt packagekit-qt
  ];
  propagatedBuildInputs = [ kconfigwidgets kiconthemes ];
}
