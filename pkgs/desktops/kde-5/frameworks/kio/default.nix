{ kdeFramework, lib, copyPathsToStore
, extra-cmake-modules, acl, karchive
, kbookmarks, kcompletion, kconfig, kconfigwidgets, kcoreaddons
, kdbusaddons, kdoctools, ki18n, kiconthemes, kitemviews
, kjobwidgets, knotifications, kservice, ktextwidgets, kwallet
, kwidgetsaddons, kwindowsystem, kxmlgui
, qtscript, qtx11extras, solid
}:

kdeFramework {
  name = "kio";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    acl karchive kbookmarks kcompletion kconfig kconfigwidgets kcoreaddons
    kdbusaddons ki18n kiconthemes kitemviews kjobwidgets knotifications kservice
    ktextwidgets kwallet kwidgetsaddons kwindowsystem kxmlgui solid qtscript
    qtx11extras
  ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
}
