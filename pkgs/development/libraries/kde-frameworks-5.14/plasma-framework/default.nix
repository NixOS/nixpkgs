{ kdeFramework, lib, extra-cmake-modules, kactivities, karchive
, kconfig, kconfigwidgets, kcoreaddons, kdbusaddons, kdeclarative
, kdoctools, kglobalaccel, kguiaddons, ki18n, kiconthemes, kio
, knotifications, kpackage, kservice, kwindowsystem, kxmlgui
, qtscript, qtx11extras
}:

kdeFramework {
  name = "plasma-framework";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    karchive kconfig kconfigwidgets kcoreaddons kdbusaddons kguiaddons
    kiconthemes kio knotifications kwindowsystem kxmlgui qtscript
  ];
  propagatedBuildInputs = [
    kactivities kdeclarative kglobalaccel ki18n kpackage kservice
    qtx11extras
  ];
  postInstall = ''
    wrapKDEProgram "$out/bin/plasmapkg2"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
