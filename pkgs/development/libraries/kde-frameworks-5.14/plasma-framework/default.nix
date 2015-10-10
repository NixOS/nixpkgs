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
    ki18n kiconthemes kio knotifications kwindowsystem kxmlgui
    qtscript qtx11extras
  ];
  propagatedBuildInputs = [
    kactivities kdeclarative kglobalaccel kpackage kservice
  ];
  postInstall = ''
    wrapKDEProgram "$out/bin/plasmapkg2"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
