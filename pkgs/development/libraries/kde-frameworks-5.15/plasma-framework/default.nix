{ kdeFramework, lib, extra-cmake-modules, kactivities, karchive
, kconfig, kconfigwidgets, kcoreaddons, kdbusaddons, kdeclarative
, kdoctools, kglobalaccel, kguiaddons, ki18n, kiconthemes, kio
, knotifications, kpackage, kservice, kwindowsystem, kxmlgui
, makeKDEWrapper, qtscript, qtx11extras
}:

kdeFramework {
  name = "plasma-framework";
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeKDEWrapper ];
  buildInputs = [
    karchive kconfig kconfigwidgets kcoreaddons kdbusaddons kguiaddons
    kiconthemes knotifications kxmlgui qtscript
  ];
  propagatedBuildInputs = [
    kactivities kdeclarative kglobalaccel ki18n kio kpackage kservice kwindowsystem
    qtx11extras
  ];
  postInstall = ''
    wrapKDEProgram "$out/bin/plasmapkg2"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
