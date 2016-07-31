{
  kdeApp, lib, ecm, kdoctools, makeQtWrapper,
  kconfig, kcoreaddons, kdbusaddons, kdeclarative, ki18n, kio, knotifications,
  kscreen, kwidgetsaddons, kwindowsystem, kxmlgui, libkipi, xcb-util-cursor
}:

kdeApp {
  name = "spectacle";
  meta = with lib; {
    maintainers = with maintainers; [ ttuegel ];
  };
  nativeBuildInputs = [ ecm kdoctools makeQtWrapper ];
  propagatedBuildInputs = [
    kconfig kcoreaddons kdbusaddons kdeclarative ki18n kio knotifications
    kscreen kwidgetsaddons kwindowsystem kxmlgui libkipi xcb-util-cursor
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/spectacle"
  '';
}
