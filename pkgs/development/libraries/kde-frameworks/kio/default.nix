{
  mkDerivation, lib, copyPathsToStore,
  extra-cmake-modules, kdoctools,
  karchive, kbookmarks, kcompletion, kconfig, kconfigwidgets, kcoreaddons,
  kdbusaddons, ki18n, kiconthemes, kitemviews, kjobwidgets, knotifications,
  kservice, ktextwidgets, kwallet, kwidgetsaddons, kwindowsystem, kxmlgui,
  qtbase, qtscript, qtx11extras, solid,
}:

mkDerivation {
  name = "kio";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    karchive kconfigwidgets kdbusaddons ki18n kiconthemes knotifications
    ktextwidgets kwallet kwidgetsaddons kwindowsystem qtscript qtx11extras
  ];
  propagatedBuildInputs = [
    kbookmarks kcompletion kconfig kcoreaddons kitemviews kjobwidgets kservice
    kxmlgui qtbase solid
  ];
  patches = (copyPathsToStore (lib.readPathsFromFile ./. ./series));
}
