{ kdeApp, lib
, extra-cmake-modules
, kdoctools
, makeQtWrapper
, kconfig
, kcoreaddons
, kdbusaddons
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
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeQtWrapper
  ];
  buildInputs = [
    kconfig
    kcoreaddons
    kdbusaddons
    ki18n
    kio
    knotifications
    kscreen
    kwidgetsaddons
    kwindowsystem
    kxmlgui
    libkipi
    xcb-util-cursor
  ];
  postFixup = ''
    wrapQtProgram "$out/bin/spectacle"
  '';
  meta = with lib; {
    maintainers = with maintainers; [ ttuegel ];
  };
}
