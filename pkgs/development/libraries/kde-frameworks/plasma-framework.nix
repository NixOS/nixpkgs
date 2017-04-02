{ kdeFramework, lib, fetchurl, extra-cmake-modules, kactivities, karchive
, kconfig, kconfigwidgets, kcoreaddons, kdbusaddons, kdeclarative
, kdoctools, kglobalaccel, kguiaddons, ki18n, kiconthemes, kio
, knotifications, kpackage, kservice, kwayland, kwindowsystem, kxmlgui
, qtscript, qtx11extras
}:

kdeFramework {
  name = "plasma-framework";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kactivities karchive kconfig kconfigwidgets kcoreaddons kdbusaddons
    kdeclarative kglobalaccel kguiaddons ki18n kiconthemes kio knotifications
    kpackage kservice kwayland kwindowsystem kxmlgui qtscript qtx11extras
  ];
}
