{ kdeApp, lib
, extra-cmake-modules
, kdoctools
, makeQtWrapper
, kconfig
, kcoreaddons
, kdbusaddons
, kdeclarative
, ki18n
, kio
, knotifications
, kscreen
, kwidgetsaddons
, kwindowsystem
, kxmlgui
, libkipi
, xcb-util-cursor
}:

kdeApp {
  name = "spectacle";
  meta = with lib; {
    maintainers = with maintainers; [ ttuegel ];
  };
  nativeBuildInputs = [
    extra-cmake-modules kdoctools makeQtWrapper
  ];
  propagatedBuildInputs = [
    kconfig kcoreaddons kdbusaddons kdeclarative ki18n kio knotifications
    kscreen kwidgetsaddons kwindowsystem kxmlgui libkipi xcb-util-cursor
  ];
  postFixup = ''
    wrapQtProgram "$out/bin/spectacle"
  '';
}
