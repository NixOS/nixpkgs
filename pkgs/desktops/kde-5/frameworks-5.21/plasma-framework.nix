{ kdeFramework, lib, extra-cmake-modules, kactivities, karchive
, kconfig, kconfigwidgets, kcoreaddons, kdbusaddons, kdeclarative
, kdoctools, kglobalaccel, kguiaddons, ki18n, kiconthemes, kio
, knotifications, kpackage, kservice, kwindowsystem, kxmlgui
, makeQtWrapper, qtscript, qtx11extras
}:

kdeFramework {
  name = "plasma-framework";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeQtWrapper ];
  propagatedBuildInputs = [
    kactivities karchive kconfig kconfigwidgets kcoreaddons kdbusaddons
    kdeclarative kglobalaccel kguiaddons ki18n kiconthemes kio knotifications
    kpackage kservice kwindowsystem kxmlgui qtscript qtx11extras
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/plasmapkg2"
  '';
}
